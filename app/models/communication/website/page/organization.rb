class Communication::Website::Page::Organization < Communication::Website::Page

  def design_options_block_template_kind
    :organizations
  end

  def dependencies
    super +
    [website.config_default_languages] +
    explicitly_connected_organizations
  end

  # https://developers.osuny.org/docs/admin/sites-web/git/dependencies/iteration-9/
  def references
    website.connected_organizations
  end

  # For implicit connections, direct_source_type is "Communication::Website::Page"
  # Whereas for explicit, it will be "Communication::Website::Page::Organization"
  def explicitly_connected_organizations
    ids = website.connections.where(
            indirect_object_type: 'University::Organization',
            direct_source_type: 'Communication::Website::Page::Organization',
            direct_source_id: self.id
          ).pluck(:indirect_object_id)
    University::Organization.where(id: ids)
  end

  def self.direct_connection_permitted_about_class
    University::Organization
  end

  def git_path_relative
    'organizations/_index.html'
  end

  def special_page_categories
    university.organization_categories
  end
end
