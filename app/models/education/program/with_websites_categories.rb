module Education::Program::WithWebsitesCategories
  extend ActiveSupport::Concern

  included do
    after_save_commit :set_websites_categories

    has_many   :website_agenda_categories,
               class_name: 'Communication::Website::Agenda::Category',
               dependent: :destroy

    has_many   :website_portfolio_categories,
               class_name: 'Communication::Website::Portfolio::Category',
               dependent: :destroy

    has_many   :website_post_categories,
               class_name: 'Communication::Website::Post::Category',
               dependent: :destroy
  end

  def set_websites_categories
    websites.each { |website| website.set_programs_categories }
  end

  def website_category_l10ns_for(website, language)
    categories = {}
    categories[:agenda] = website_agenda_categories.find_by(communication_website_id: website.id)&.localization_for(language)
    categories[:blog] = website_post_categories.find_by(communication_website_id: website.id)&.localization_for(language)
    categories[:portfolio] = website_portfolio_categories.find_by(communication_website_id: website.id)&.localization_for(language)
    categories.compact
  end
end
