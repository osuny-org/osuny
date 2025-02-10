class AddOptionsToCommunicationWebsitePages < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_pages, :design_options, :jsonb
  end
end
