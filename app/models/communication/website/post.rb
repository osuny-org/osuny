# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  meta_description         :text
#  migration_identifier     :string
#  pinned                   :boolean          default(FALSE)
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string           indexed
#  summary                  :text
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  author_id                :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             indexed
#  original_id              :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_posts_on_author_id                 (author_id)
#  index_communication_website_posts_on_communication_website_id  (communication_website_id)
#  index_communication_website_posts_on_language_id               (language_id)
#  index_communication_website_posts_on_original_id               (original_id)
#  index_communication_website_posts_on_slug                      (slug)
#  index_communication_website_posts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1e0d058a25  (university_id => universities.id)
#  fk_rails_bbbef3b1e9  (original_id => communication_website_posts.id)
#  fk_rails_d1c1a10946  (communication_website_id => communication_websites.id)
#  fk_rails_e0eec447b0  (author_id => university_people.id)
#
class Communication::Website::Post < ApplicationRecord
  include AsDirectObject
  include Contentful # TODO L10N : To remove
  # include Initials
  include Permalinkable # TODO L10N : To remove
  include Sanitizable
  # include Shareable
  # include Sluggable # We override slug_unavailable? method
  include Localizable  # TODO L10N : To adapt
  include WithBlobs # TODO L10N : To remove
  include WithDuplication
  include WithFeaturedImage # TODO L10N : To remove
  include WithMenuItemTarget
  include WithUniversity

  has_summernote :text # TODO: Remove text attribute

  belongs_to :author,
             class_name: 'University::Person',
             optional: true
  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Post::Category',
                          join_table: :communication_website_categories_posts,
                          foreign_key: :communication_website_post_id,
                          association_foreign_key: :communication_website_category_id

  after_save_commit :update_authors_statuses!, if: :saved_change_to_author_id?

  # TODO L10N : To rewrite
  scope :published, -> {
    where("
      communication_website_posts.published = true AND
      DATE(communication_website_posts.published_at) <= now()
    ")
  }
  scope :published_in_the_future, -> {
    where("
      communication_website_posts.published = true AND
      DATE(communication_website_posts.published_at) > now()
    ")
  }
  scope :ordered, -> (language) { order(pinned: :desc, published_at: :desc, created_at: :desc) }
  scope :latest, -> { published.order(published_at: :desc).limit(5) }
  scope :for_author, -> (author_id) { where(author_id: author_id) }
  scope :for_category, -> (category_id) { joins(:categories).where(communication_website_post_categories: { id: category_id }).distinct }
  scope :for_pinned, -> (pinned) { where(pinned: pinned == 'true') }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_website_posts.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_posts.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_posts.text) ILIKE unaccent(:term) OR
      unaccent(communication_website_posts.title) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    localizations +
    categories +
    [author&.author] +
    [website.config_default_content_security_policy]
  end

  def references
    menus +
    abouts_with_post_block
  end

  def pinned_in?(language)
    localization_for(language).try(:pinned)
  end

  def published_at_in(language)
    localization_for(language).try(:published_at)
  end

  protected

  def update_authors_statuses!
    old_author = University::Person.find_by(id: author_id_before_last_save)
    if old_author && old_author.communication_website_posts.none?
      old_author.update(is_author: false)
    end
    author.update(is_author: true) if author_id
  end

  def abouts_with_post_block
    website.blocks.posts.collect(&:about)
    # Potentiel gain de performance (25%)
    # Méthode collect : X abouts = X requêtes
    # Méthode ci-dessous : X abouts = 6 requêtes
    # website.post_categories.where(id: website.blocks.posts.where(about_type: "Communication::Website::Post::Category").distinct.pluck(:about_id)) +
    # website.pages.where(id: website.blocks.posts.where(about_type: "Communication::Website::Page").distinct.pluck(:about_id)) +
    # website.posts.where(id: website.blocks.posts.where(about_type: "Communication::Website::Post").distinct.pluck(:about_id))
  end
end
