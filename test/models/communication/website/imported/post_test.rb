# == Schema Information
#
# Table name: communication_website_imported_posts
#
#  id            :uuid             not null, primary key
#  content       :text
#  description   :text
#  identifier    :string
#  path          :text
#  published_at  :datetime
#  status        :integer          default(0)
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  post_id       :uuid             not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_posts_on_post_id        (post_id)
#  index_communication_website_imported_posts_on_university_id  (university_id)
#  index_communication_website_imported_posts_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => communication_website_posts.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
require "test_helper"

class Communication::Website::Imported::PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
