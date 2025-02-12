class CreateCommunicationWebsiteAgendaEventDays < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_event_days, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :communication_website_agenda_event, null: false, foreign_key: true, type: :uuid
      t.date :date

      t.timestamps
    end
  end
end
