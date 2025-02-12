class CreateJoinTableCommunicationWebsiteAgendaExhibitionsCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_categories_exhibitions, id: :uuid do |t|
      t.references :category, null: false, foreign_key: {to_table: :communication_website_agenda_categories}, type: :uuid
      t.references :exhibition, null: false, foreign_key: {to_table: :communication_website_agenda_exhibitions}, type: :uuid
    end
  end
end
