module Communication::Website::WithFeatureAgenda
  extend ActiveSupport::Concern

  included do
    has_many    :agenda_events,
                class_name: "Communication::Website::Agenda::Event",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :events :agenda_events

    has_many    :agenda_exhibitions,
                class_name: "Communication::Website::Agenda::Exhibition",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :exhibitions :agenda_exhibitions

    has_many    :agenda_categories,
                class_name: 'Communication::Website::Agenda::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

    scope :with_feature_agenda, -> { where(feature_agenda: true) }
  end

  def feature_agenda_name(language)
    begin
      special_page(Communication::Website::Page::CommunicationAgenda).best_localization_for(language)
    rescue
      Communication::Website::Agenda::Event.model_name.human(count: 2)
    end
  end

end