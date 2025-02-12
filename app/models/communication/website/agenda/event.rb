# == Schema Information
#
# Table name: communication_website_agenda_events
#
#  id                       :uuid             not null, primary key
#  from_day                 :date
#  from_hour                :time
#  migration_identifier     :string
#  time_zone                :string
#  to_day                   :date
#  to_hour                  :time
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  created_by_id            :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_agenda_events_on_communication_website_id             (communication_website_id)
#  index_communication_website_agenda_events_on_created_by_id  (created_by_id)
#  index_communication_website_agenda_events_on_parent_id      (parent_id)
#  index_communication_website_agenda_events_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_00ca585c35  (university_id => universities.id)
#  fk_rails_5fa53206f2  (communication_website_id => communication_websites.id)
#  fk_rails_917095d5ca  (parent_id => communication_website_agenda_events.id)
#  fk_rails_c9e737a3c1  (created_by_id => users.id)
#
class Communication::Website::Agenda::Event < ApplicationRecord
  include AsDirectObject
  include Duplicable
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include InTime
  include Sanitizable
  include Searchable
  include Localizable
  include WithDays
  include WithTimeSlots
  include WithKinds
  include WithMenuItemTarget
  include WithOpenApi
  include WithTree
  include WithUniversity

  belongs_to  :created_by,
              class_name: "User",
              optional: true

  belongs_to  :parent,
              class_name: 'Communication::Website::Agenda::Event',
              optional: true
  has_many    :children,
              class_name: 'Communication::Website::Agenda::Event',
              foreign_key: :parent_id,
              dependent: :destroy

  scope :ordered_desc, -> { order(from_day: :desc, from_hour: :desc) }
  scope :ordered_asc, -> { order(:from_day, :from_hour) }
  scope :ordered, -> (language = nil) { ordered_asc }
  scope :latest_in, -> (language) { published_now_in(language).future_or_current.order("communication_website_agenda_event_localizations.updated_at").limit(5) }

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_website_agenda_event_localizations: { language_id: language.id })
      . where("
      unaccent(communication_website_agenda_event_localizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_event_localizations.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_event_localizations.title) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_event_localizations.subtitle) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids) +
    [parent] +
    days
  end

  def references
    menus +
    abouts_with_agenda_block
  end

  protected

  # TODO refactor that with service or addition to DateTime (ex: DateTime.merge(date, time))
  def time_with(day, hour)
    DateTime.new  day.year,
                  day.month,
                  day.day,
                  hour.hour,
                  hour.min
  end

  def abouts_with_agenda_block
    website.blocks.template_agenda.collect(&:about)
  end
end
