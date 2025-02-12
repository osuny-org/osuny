# == Schema Information
#
# Table name: communication_website_agenda_exhibitions
#
#  id                       :uuid             not null, primary key
#  from_day                 :date
#  migration_identifier     :string
#  time_zone                :string
#  to_day                   :date
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  created_by_id            :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_created_by_id_c3766f3a0a                       (created_by_id)
#  idx_on_university_id_46e895f493                       (university_id)
#  index_agenda_exhibitions_on_communication_website_id  (communication_website_id)
#
# Foreign Keys
#
#  fk_rails_28f367ca06  (created_by_id => users.id)
#  fk_rails_29241f0afb  (university_id => universities.id)
#  fk_rails_4c477c4153  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Exhibition < ApplicationRecord
  include AsDirectObject
  include Duplicable
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include InTime
  include Sanitizable
  include Searchable
  include Localizable
  include WithMenuItemTarget
  include WithOpenApi
  include WithUniversity

  belongs_to  :created_by,
              class_name: "User",
              optional: true

  validates :from_day, presence: true
  validates :to_day, presence: true, comparison: { greater_than: :from_day }

  scope :ordered_desc, -> { order(from_day: :desc) }
  scope :ordered_asc, -> { order(:from_day) }
  scope :ordered, -> (language = nil) { ordered_asc }

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_website_agenda_exhibition_localizations: { language_id: language.id })
      . where("
      unaccent(communication_website_agenda_exhibition_localizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_exhibition_localizations.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_exhibition_localizations.title) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_exhibition_localizations.subtitle) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids)
  end

  def references
    menus +
    abouts_with_agenda_block
  end

  protected

  def abouts_with_agenda_block
    website.blocks.template_agenda.collect(&:about)
  end
end
