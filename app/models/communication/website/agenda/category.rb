# == Schema Information
#
# Table name: communication_website_agenda_categories
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  is_programs_root         :boolean          default(FALSE)
#  is_taxonomy              :boolean          default(FALSE)
#  position                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  parent_id                :uuid             indexed
#  program_id               :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_communication_website_agenda_cats_on_website_id             (communication_website_id)
#  index_communication_website_agenda_categories_on_parent_id      (parent_id)
#  index_communication_website_agenda_categories_on_program_id     (program_id)
#  index_communication_website_agenda_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_692dbf7723  (parent_id => communication_website_agenda_categories.id)
#  fk_rails_6cb9a4b8a1  (university_id => universities.id)
#  fk_rails_6cd2d2d97e  (program_id => education_programs.id)
#  fk_rails_7b5ad84dda  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Category < ApplicationRecord
  include AsCategory
  include AsDirectObject
  include Localizable
  include Sanitizable
  include WithMenuItemTarget
  include WithUniversity

  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_and_belongs_to_many :events
  alias                   :category_objects :events
  has_and_belongs_to_many :exhibitions

  def event_localizations
    Communication::Website::Agenda::Event::Localization.where(about_id: event_ids)
  end

  def dependencies
    [parent] +
    localizations.in_languages(website.active_language_ids) +
    [website.config_default_content_security_policy]
  end

  def references
    events +
    event_localizations +
    website.menus.in_languages(website.active_language_ids) +
    [parent]
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    website.agenda_categories.where(parent_id: parent_id).ordered.last
  end

end
