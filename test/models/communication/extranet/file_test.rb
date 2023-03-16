# == Schema Information
#
# Table name: communication_extranet_files
#
#  id            :uuid             not null, primary key
#  name          :string
#  published     :boolean
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_files_on_extranet_id    (extranet_id)
#  index_communication_extranet_files_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_1272fd263c  (extranet_id => communication_extranets.id)
#  fk_rails_af877a8c0c  (university_id => universities.id)
#
require "test_helper"

class Communication::Extranet::FileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
