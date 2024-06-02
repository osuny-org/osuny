SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :innernav_posts,
                  Communication::Website::Post.model_name.human(count: 2),
                  admin_communication_website_posts_path(website_id: @website.id),
                  highlights_on: lambda { 
                    controller_name == "posts" && action_name == "index" 
                  }
    primary.item  :innernav_categories,
                  Communication::Website::Post::Category.model_name.human(count: 2),
                  admin_communication_website_post_categories_path(website_id: @website.id)
    primary.item  :innernav_authors,
                  t('communication.authors', count: 2),
                  admin_communication_website_post_authors_path(website_id: @website.id)
  end
end
