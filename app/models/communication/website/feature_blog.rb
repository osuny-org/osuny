module Communication::Website::FeatureBlog
  extend ActiveSupport::Concern

  included do
    has_many    :posts,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :authors, -> { distinct }, through: :posts

    has_many    :post_categories,
                class_name: 'Communication::Website::Post::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy
  end

  def has_blog_posts?
    posts.published.any?
  end

  def has_blog_categories?
    post_categories.any?
  end
end