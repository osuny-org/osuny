class Communication::Website::Permalink::Volume < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.about.is_a? Research::Journal
  end

  def self.static_config_key
    :volumes
  end

  # /volumes/:slug/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:year-:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::ResearchVolume
  end

  protected

  def published?
    about.published && about.published_at
  end

  def substitutions
    {
      year: about.published_at.strftime("%Y"),
      slug: about.slug
    }
  end
end
