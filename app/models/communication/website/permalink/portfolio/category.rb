class Communication::Website::Permalink::Portfolio::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_portfolio
  end

  def self.static_config_key
    :projects_categories
  end

  # /projets/:slug/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/"
  end

  def special_page_type
    Communication::Website::Page::CommunicationPortfolio
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    {
      slug: about.slug
    }
  end

end
