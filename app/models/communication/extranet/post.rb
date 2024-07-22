# == Schema Information
#
# Table name: communication_extranet_posts
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  pinned                :boolean          default(FALSE)
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string           indexed
#  summary               :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :uuid             indexed
#  category_id           :uuid             indexed
#  extranet_id           :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_posts_on_author_id      (author_id)
#  index_communication_extranet_posts_on_category_id    (category_id)
#  index_communication_extranet_posts_on_extranet_id    (extranet_id)
#  index_communication_extranet_posts_on_slug           (slug)
#  index_communication_extranet_posts_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_0232de42a1  (university_id => universities.id)
#  fk_rails_4341823eab  (extranet_id => communication_extranets.id)
#  fk_rails_7827da1fd1  (category_id => communication_extranet_post_categories.id)
#  fk_rails_86cc935add  (author_id => university_people.id)
#
class Communication::Extranet::Post < ApplicationRecord
  include Contentful
  include Permalinkable
  include Sanitizable
  include WithAccessibility
  include WithFeaturedImage
  include WithPublication
  include WithUniversity

  belongs_to :author, class_name: 'University::Person', optional: true
  belongs_to :category, class_name: 'Communication::Extranet::Post::Category', optional: true
  belongs_to :extranet, class_name: 'Communication::Extranet'

  validates :title, presence: true

  scope :ordered, -> { order(pinned: :desc, published_at: :desc, created_at: :desc) }

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(extranet_id: self.extranet_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end
end
