# == Schema Information
#
# Table name: communication_website_agenda_event_time_slot_localizations
#
#  id                       :uuid             not null, primary key
#  duration                 :integer
#  place                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             not null, indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :bigint           indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_e52a2e12b0                  (about_id)
#  idx_on_communication_website_id_526f156fed  (communication_website_id)
#  idx_on_language_id_f50f565794               (language_id)
#  idx_on_university_id_4dee92bcc5             (university_id)
#
# Foreign Keys
#
#  fk_rails_058062d234  (university_id => universities.id)
#  fk_rails_641e55dd7e  (about_id => communication_website_agenda_event_time_slots.id)
#  fk_rails_ef5c90fa45  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Event::TimeSlot::Localization < ApplicationRecord
  include AsLocalization
  include WithGitFiles
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :time_slot :about
end
