class CreateUniversityPersonInvolvementLocalizations < ActiveRecord::Migration[7.1]
  def change
    create_table :university_person_involvement_localizations, id: :uuid do |t|
      t.text :description

      t.references :about, foreign_key: { to_table: :university_person_involvements }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
