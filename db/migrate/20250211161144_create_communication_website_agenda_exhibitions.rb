class CreateCommunicationWebsiteAgendaExhibitions < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_exhibitions, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid, index: { name: 'index_agenda_exhibitions_on_communication_website_id' }
      t.references :created_by, foreign_key: { to_table: :users }, type: :uuid
      t.date :from_day
      t.date :to_day
      t.string :migration_identifier
      t.string :time_zone

      t.timestamps
    end

    create_table :communication_website_agenda_exhibition_localizations, id: :uuid do |t|
      t.jsonb :add_to_calendar_urls
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.boolean :header_cta
      t.string :header_cta_label
      t.string :header_cta_url
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.string :subtitle
      t.text :summary
      t.string :title
      t.references :about, null: false, foreign_key: { to_table: :communication_website_agenda_exhibitions }, type: :uuid
      t.references :language, null: false, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
