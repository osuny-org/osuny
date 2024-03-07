class Communication::Website::Permalink::Portfolio::Project < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_portfolio
  end

  def self.static_config_key
    :projects
  end

  # /projets/2022-lac-project/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::CommunicationPortfolio, language: language).slug_with_ancestors}/:year-:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      year: about.from_day.strftime("%Y"),
      slug: about.slug
    }
  end

end
