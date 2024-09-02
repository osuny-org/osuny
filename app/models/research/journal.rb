# == Schema Information
#
# Table name: research_journals
#
#  id               :uuid             not null, primary key
#  issn             :string
#  meta_description :text
#  summary          :text
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  language_id      :uuid             indexed
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_research_journals_on_language_id    (language_id)
#  index_research_journals_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_7d3b3f3e79  (language_id => languages.id)
#  fk_rails_96097d5f10  (university_id => universities.id)
#
class Research::Journal < ApplicationRecord
  include AsIndirectObject
  include Favoritable
  include Localizable
  include Sanitizable
  include WebsitesLinkable
  include WithUniversity

  belongs_to :language, optional: true # TODO L10N : To remove
  has_many  :communication_websites,
            class_name: 'Communication::Website',
            as: :about,
            dependent: :nullify
  has_many  :volumes,
            foreign_key: :research_journal_id,
            dependent: :destroy
  has_many  :published_volumes,
            -> { published },
            class_name: 'Research::Journal::Volume',
            foreign_key: :research_journal_id,
            dependent: :destroy
  has_many  :papers,
            foreign_key: :research_journal_id,
            dependent: :destroy
  has_many  :published_papers,
            -> { published },
            class_name: 'Research::Journal::Paper',
            foreign_key: :research_journal_id,
            dependent: :destroy
  has_many  :people,
            -> { distinct },
            through: :papers
  has_many  :people_through_published_papers,
            -> { distinct },
            through: :published_papers,
            source: :people
  has_many  :kinds,
            class_name: 'Research::Journal::Paper::Kind'

  scope :ordered, -> { order(:title) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(research_journals.meta_description) ILIKE unaccent(:term) OR
      unaccent(research_journals.issn) ILIKE unaccent(:term) OR
      unaccent(research_journals.repository) ILIKE unaccent(:term) OR
      unaccent(research_journals.title) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_language, -> (language) { for_language_id(language.id) }
  # The for_language_id scope can be used when you have the ID without needing to load the Language itself
  scope :for_language_id, -> (language_id) { where(language_id: language_id) }

  def researchers
    university.people.where(id: people_through_published_papers.pluck(:id), is_researcher: true)
  end

  def dependencies
    localizations +
    volumes +
    papers +
    researchers.map(&:researcher)
  end

  #####################
  # WebsitesLinkable methods #
  #####################
  def has_administrators?
    false
  end

  def has_researchers?
    researchers.any?
  end

  def has_teachers?
    false
  end

  def has_education_programs?
    false
  end

  def has_education_diplomas?
    false
  end
  
  def has_administration_locations?
    false
  end

  def has_research_papers?
    published_papers.published.any?
  end

  def has_research_volumes?
    published_volumes.published.any?
  end
end
