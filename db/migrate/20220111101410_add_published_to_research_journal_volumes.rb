class AddPublishedToResearchJournalVolumes < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_volumes, :published, :boolean, default: false
  end
end
