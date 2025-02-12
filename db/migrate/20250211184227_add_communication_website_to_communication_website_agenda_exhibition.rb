class AddCommunicationWebsiteToCommunicationWebsiteAgendaExhibition < ActiveRecord::Migration[7.2]
  def change
    add_reference :communication_website_agenda_exhibition_localizations, :communication_website, null: false, foreign_key: true, type: :uuid
  end
end
