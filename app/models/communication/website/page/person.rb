class Communication::Website::Page::Person < Communication::Website::Page

  def design_options_block_template_kind
    :persons
  end

  def dependencies
    super +
    [website.config_default_languages] +
    explicitly_connected_people
  end

  # https://developers.osuny.org/docs/admin/sites-web/git/dependencies/iteration-9/
  def references
    website.connected_people
  end

  # For implicit connections, direct_source_type is "Communication::Website::Page"
  # Whereas for explicit, it will be "Communication::Website::Page::Person"
  def explicitly_connected_people
    ids = website.connections.where(
            indirect_object_type: 'University::Person',
            direct_source_type: 'Communication::Website::Page::Person',
            direct_source_id: self.id
          ).pluck(:indirect_object_id)
    University::Person.where(id: ids)
  end

  def self.direct_connection_permitted_about_class
    University::Person
  end

  def git_path_relative
    'persons/_index.html'
  end

  def special_page_categories
    university.person_categories
  end
end
