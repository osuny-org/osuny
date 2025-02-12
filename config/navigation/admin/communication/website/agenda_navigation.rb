SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_events,
                  @website.feature_agenda_name(current_language),
                  admin_communication_website_agenda_events_path(website_id: @website.id)
    primary.item  :feature_nav_exhibitions,
                  Communication::Website::Agenda::Exhibition.model_name.human(count: 2),
                  admin_communication_website_agenda_exhibitions_path(website_id: @website.id)
    primary.item  :feature_nav_categories,
                  Communication::Website::Agenda::Category.model_name.human(count: 2),
                  admin_communication_website_agenda_categories_path(website_id: @website.id)
  end
end
