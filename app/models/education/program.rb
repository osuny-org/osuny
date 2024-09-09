# == Schema Information
#
# Table name: education_programs
#
#  id                     :uuid             not null, primary key
#  accessibility          :text
#  apprenticeship         :boolean
#  bodyclass              :string
#  capacity               :integer
#  contacts               :text
#  content                :text
#  continuing             :boolean
#  duration               :string
#  evaluation             :text
#  featured_image_alt     :string
#  featured_image_credit  :text
#  initial                :boolean
#  meta_description       :text
#  name                   :string
#  objectives             :text
#  opportunities          :text
#  other                  :text
#  path                   :string
#  pedagogy               :text
#  position               :integer          default(0)
#  prerequisites          :text
#  presentation           :text
#  pricing                :text
#  pricing_apprenticeship :text
#  pricing_continuing     :text
#  pricing_initial        :text
#  published              :boolean          default(FALSE)
#  qualiopi_certified     :boolean          default(FALSE)
#  qualiopi_text          :text
#  registration           :text
#  registration_url       :string
#  results                :text
#  short_name             :string
#  slug                   :string           indexed
#  summary                :text
#  url                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  diploma_id             :uuid             indexed
#  language_id            :uuid             indexed
#  original_id            :uuid             indexed
#  parent_id              :uuid             indexed
#  university_id          :uuid             not null, indexed
#
# Indexes
#
#  index_education_programs_on_diploma_id     (diploma_id)
#  index_education_programs_on_language_id    (language_id)
#  index_education_programs_on_original_id    (original_id)
#  index_education_programs_on_parent_id      (parent_id)
#  index_education_programs_on_slug           (slug)
#  index_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_08b351087c  (university_id => universities.id)
#  fk_rails_2c27955cee  (original_id => education_programs.id)
#  fk_rails_e2f027eb9e  (language_id => languages.id)
#  fk_rails_ec1f16f607  (parent_id => education_programs.id)
#
class Education::Program < ApplicationRecord
  include AsIndirectObject
  include Contentful # TODO L10N : To remove
  include Sanitizable
  include Shareable # TODO L10N : To remove
  include Localizable
  include WebsitesLinkable
  include WithAlumni
  include WithBlobs # TODO L10N : To remove
  include WithDiploma
  include WithFeaturedImage # TODO L10N : To remove
  include WithLocations
  include WithMenuItemTarget
  include WithPosition
  include WithSchools
  include WithTeam
  include WithTree
  include WithUniversity
  include WithWebsitesCategories

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true

  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id


  has_one_attached_deletable :downloadable_summary # TODO L10N : To remove
  has_one_attached_deletable :logo # TODO L10N : To remove

  before_destroy :move_children

  scope :ordered_by_name, -> (language) {
    # Define a raw SQL snippet for the conditional aggregation
    # This selects the name of the localization in the specified language,
    # or falls back to the first localization name if the specified language is not present.
    localization_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.name))) END),
        MAX(TRIM(LOWER(UNACCENT(localizations.name)))) FILTER (WHERE localizations.rank = 1)
      ) AS localization_name
    SQL

    # Join the programs table with a subquery that ranks localizations
    # The subquery assigns a rank to each localization, with 1 being the first localization for each organization
    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          education_program_localizations as localizations
      ) localizations ON education_programs.id = localizations.about_id
    SQL
    ]))
    .select("education_programs.*", localization_name_select)
    .group("education_programs.id")
    .order("localization_name ASC")
  }
  # TODO L10N : adjust
  scope :for_search_term, -> (term) {
    where("
      unaccent(education_programs.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_diploma, -> (diploma_id) {
    where(diploma_id: diploma_id)
  }
  scope :for_school, -> (school_id) {
    joins(:schools)
      .where(education_schools: { id: school_id })
      .distinct
  }
  scope :for_publication, -> (publication) {
    where(published: publication)
  }

  def dependencies
    active_storage_blobs +
    locations +
    university_people_through_involvements.map(&:teacher) +
    university_people_through_role_involvements.map(&:administrator) +
    [diploma]
  end

  def references
    schools +
    siblings +
    descendants +
    [parent]
  end

  #####################
  # WebsitesLinkable methods
  #####################

  def has_administrators?
    university_people_through_role_involvements.any? ||
    descendants.any? { |descendant| descendant.university_people_through_role_involvements.any? }
  end

  def has_researchers?
    false
  end

  def has_teachers?
    university_people_through_involvements.any? ||
    descendants.any? { |descendant| descendant.university_people_through_involvements.any? }
  end

  def has_education_programs?
    published? || descendants.any?(&:published?)
  end

  def has_education_diplomas?
    diploma.present? || descendants.any? { |descendant| descendant.diploma.present? }
  end

  def has_research_papers?
    false
  end

  def has_research_volumes?
    false
  end

  def programs
    Education::Program.where(id: id)
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def last_ordered_element
    university.education_programs.where(parent_id: parent_id).ordered.last
  end

  def move_children
    children.update(parent_id: parent_id)
  end

end
