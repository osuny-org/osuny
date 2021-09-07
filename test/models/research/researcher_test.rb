# == Schema Information
#
# Table name: research_researchers
#
#  id         :uuid             not null, primary key
#  biography  :text
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_research_researchers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class Research::ResearcherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
