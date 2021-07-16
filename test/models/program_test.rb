# == Schema Information
#
# Table name: programs
#
#  id            :uuid             not null, primary key
#  accessibility :text
#  capacity      :integer
#  contacts      :text
#  continuing    :boolean
#  duration      :text
#  ects          :integer
#  evaluation    :text
#  level         :integer
#  name          :string
#  objectives    :text
#  pedagogy      :text
#  prerequisites :text
#  pricing       :text
#  registration  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
require "test_helper"

class ProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
