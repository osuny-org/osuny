class Communication::Website::Page::CommunicationAgenda < Communication::Website::Page

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
    website.events
  end

  def git_path_relative
    'events/_index.html'
  end
end
