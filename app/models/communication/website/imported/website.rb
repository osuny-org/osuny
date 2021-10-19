# == Schema Information
#
# Table name: communication_website_imported_websites
#
#  id            :uuid             not null, primary key
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_websites_on_university_id  (university_id)
#  index_communication_website_imported_websites_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::Imported::Website < ApplicationRecord
  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website'
  has_many   :media,
             class_name: 'Communication::Website::Imported::Medium'
  has_many   :pages,
             class_name: 'Communication::Website::Imported::Page'
  has_many   :posts,
             class_name: 'Communication::Website::Imported::Post'

  def run!
    sync_media
    sync_pages
    sync_posts
  end

  protected

  def wordpress
    @wordpress ||= Wordpress.new website.domain_url
  end

  def sync_media
    wordpress.media.each do |data|
      medium = media.where(university: university, identifier: data['id']).first_or_create
      medium.data = data
      medium.save
    end
  end

  def sync_pages
    wordpress.pages.each do |data|
      page = pages.where(university: university, identifier: data['id']).first_or_create
      page.data = data
      page.save
    end
    # TODO parents
  end

  def sync_posts
    wordpress.posts.each do |data|
      post = posts.where(university: university, identifier: data['id']).first_or_create
      post.data = data
      post.save
    end
  end
end
