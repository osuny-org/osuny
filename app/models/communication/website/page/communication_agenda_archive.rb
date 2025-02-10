class Communication::Website::Page::CommunicationAgendaArchive < Communication::Website::Page

  def design_options_block_template_kind
    :agenda
  end

 def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def is_necessary_for_website?
    website.feature_agenda
  end

  # Not listed in any menu because it makes "Agenda" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.events
  end

  def default_parent
    website.special_page(Communication::Website::Page::CommunicationAgenda)
  end

  def git_path_relative
    'events/archives/_index.html'
  end
end
