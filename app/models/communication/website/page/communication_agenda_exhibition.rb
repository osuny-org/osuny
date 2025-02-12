class Communication::Website::Page::CommunicationAgendaExhibition < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def is_necessary_for_website?
    website.feature_agenda
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.exhibitions
  end

  def git_path_relative
    'exhibitions/_index.html'
  end

  def special_page_categories
    website.agenda_categories
  end
end
