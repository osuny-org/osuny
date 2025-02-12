class Communication::Website::Permalink::Agenda::Exhibition < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :exhibitions
  end

  # /expositions/2022-10-21-pulse/
  def self.pattern_in_website(website, language)
    special_page_path(website, language) + '/:year-:month-:day-:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgendaExhibition
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      year: about.from_day.strftime("%Y"),
      month: about.from_day.strftime("%m"),
      day: about.from_day.strftime("%d"),
      slug: about.slug
    }
  end

end
