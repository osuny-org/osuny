class Communication::Website::Page::Administrator < Communication::Website::Page

  def design_options_block_template_kind
    :persons
  end

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:administrators)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    dependencies_administrators
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def git_path_relative
    'administrators/_index.html'
  end

  protected

  def dependencies_administrators
    University::Person::Localization::Administrator.where(
      about_id: website.administrators.pluck(:id),
      language_id: website.active_language_ids
    )
  end

  def default_parent
    website.special_page(Communication::Website::Page::Person)
  end
end
