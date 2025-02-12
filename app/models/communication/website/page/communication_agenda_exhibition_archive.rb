class Communication::Website::Page::CommunicationAgendaExhibitionArchive < Communication::Website::Page
  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def is_necessary_for_website?
    website.feature_agenda
  end

  # Not listed in any menu because it makes "Exhibition" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.exhibitions
  end

  def default_parent
    website.special_page(Communication::Website::Page::CommunicationAgendaExhibition)
  end

  def git_path_relative
    'exhibitions/archives/_index.html'
  end
end
