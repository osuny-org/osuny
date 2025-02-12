class CreateCommunicationWebsiteAgendaEventTimeSlots < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_event_time_slots, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :communication_website_agenda_event, null: false, foreign_key: true, type: :uuid
      t.datetime :datetime
      t.integer :duration

      t.timestamps
    end
    create_table :communication_website_agenda_event_time_slot_localizations, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :about, null: false, foreign_key: {to_table: :communication_website_agenda_event_time_slots}, type: :uuid
      t.references :language
      t.integer :duration
      t.string :place

      t.timestamps
    end
  end
end
