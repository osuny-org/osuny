SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_events,
                  Communication::Website::Portfolio::Project.model_name.human(count: 2),
                  admin_communication_website_portfolio_projects_path(website_id: @website.id)
    primary.item  :fearture_nav_categories,
                  Communication::Website::Portfolio::Category.model_name.human(count: 2),
                  admin_communication_website_portfolio_categories_path(website_id: @website.id)
  end
end
