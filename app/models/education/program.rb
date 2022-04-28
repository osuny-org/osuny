# == Schema Information
#
# Table name: education_programs
#
#  id                 :uuid             not null, primary key
#  accessibility      :text
#  capacity           :integer
#  contacts           :text
#  content            :text
#  continuing         :boolean
#  description        :text
#  duration           :text
#  ects               :integer
#  evaluation         :text
#  featured_image_alt :string
#  level              :integer
#  main_information   :text
#  name               :string
#  objectives         :text
#  opportunities      :text
#  other              :text
#  path               :string
#  pedagogy           :text
#  position           :integer          default(0)
#  prerequisites      :text
#  presentation       :text
#  pricing            :text
#  published          :boolean          default(FALSE)
#  registration       :text
#  results            :text
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_id          :uuid             indexed
#  university_id      :uuid             not null, indexed
#
# Indexes
#
#  index_education_programs_on_parent_id      (parent_id)
#  index_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_08b351087c  (university_id => universities.id)
#  fk_rails_ec1f16f607  (parent_id => education_programs.id)
#
class Education::Program < ApplicationRecord
  include Aboutable
  include Sanitizable
  include WithUniversity
  include WithGit
  include WithFeaturedImage
  include WithBlobs
  include WithMenuItemTarget
  include WithSlug
  include WithTree
  include WithInheritance
  include WithPosition
  include WithBlocks

  rich_text_areas_with_inheritance  :main_information,
                                    :accessibility,
                                    :contacts,
                                    :duration,
                                    :evaluation,
                                    :objectives,
                                    :opportunities,
                                    :other,
                                    :pedagogy,
                                    :prerequisites,
                                    :presentation,
                                    :pricing,
                                    :registration,
                                    :content,
                                    :results

  attr_accessor :skip_websites_categories_callback

  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true
  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id,
             dependent: :destroy
  has_many   :university_roles,
             class_name: 'University::Role',
             as: :target,
             dependent: :destroy
  has_many   :involvements_through_roles,
             through: :university_roles,
             source: :involvements
  has_many   :university_people_through_role_involvements,
             through: :involvements_through_roles,
             source: :person
  has_many   :university_person_involvements,
             class_name: 'University::Person::Involvement',
             as: :target,
             inverse_of: :target,
             dependent: :destroy
  has_many   :university_people_through_involvements,
             through: :university_person_involvements,
             source: :person
  has_many   :website_categories,
             class_name: 'Communication::Website::Category',
             dependent: :destroy
  has_and_belongs_to_many :schools,
                          class_name: 'Education::School',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_program_id',
                          association_foreign_key: 'education_school_id'
  has_many   :websites,
             -> { distinct },
             through: :schools

  has_many   :cohorts,
             class_name: 'Education::Cohort'

  has_many   :alumni,
             through: :cohorts,
             source: :people

  has_many   :alumni_experiences,
             -> { distinct },
             class_name: 'University::Person::Experience',
             through: :alumni,
             source: :experiences
  alias_attribute :experiences, :alumni_experiences

  has_many   :alumni_organizations,
             -> { distinct },
             class_name: 'University::Organization',
             through: :alumni_experiences,
             source: :organization

  has_many   :academic_years,
             through: :cohorts

   # Dénormalisation des alumni pour le faceted search
   has_and_belongs_to_many   :university_people,
                             class_name: 'University::Person',
                             foreign_key: 'education_program_id',
                             association_foreign_key: 'university_person_id'

  accepts_nested_attributes_for :university_person_involvements, reject_if: :all_blank, allow_destroy: true

  enum level: {
    not_applicable: 0,
    primary: 40,
    secondary: 60,
    high: 80,
    first_year: 100,
    second_year: 200,
    dut: 210,
    bachelor: 300,
    master: 500,
    doctor: 800
  }

  validates_presence_of :name

  after_save :update_children_paths, if: :saved_change_to_path?
  after_save_commit :set_websites_categories, unless: :skip_websites_categories_callback

  scope :published, -> { where(published: true) }

  def to_s
    "#{name}"
  end

  def best_featured_image(fallback: true)
    return featured_image if featured_image.attached?
    best_image = parent&.best_featured_image(fallback: false)
    best_image ||= featured_image if fallback
    best_image
  end

  def git_path(website)
    "content/programs/#{path}/_index.html"
  end

  def git_dependencies(website)
    [self] +
    active_storage_blobs +
    git_block_dependencies +
    university_people_through_involvements +
    university_people_through_involvements.map(&:active_storage_blobs).flatten +
    university_people_through_involvements.map(&:teacher) +
    university_people_through_role_involvements +
    university_people_through_role_involvements.map(&:active_storage_blobs).flatten +
    university_people_through_role_involvements.map(&:administrator) +
    website.menus
  end

  def git_destroy_dependencies(website)
    [self] +
    explicit_active_storage_blobs
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  def set_websites_categories
    websites.find_each(&:set_programs_categories!)
  end

  #####################
  # Aboutable methods #
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

  def has_research_articles?
    false
  end

  def has_research_volumes?
    false
  end

  protected

  def last_ordered_element
    university.education_programs.where(parent_id: parent_id).ordered.last
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
