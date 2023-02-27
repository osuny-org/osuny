# == Schema Information
#
# Table name: communication_extranets
#
#  id                         :uuid             not null, primary key
#  about_type                 :string           indexed => [about_id]
#  color                      :string
#  cookies_policy             :text
#  feature_alumni             :boolean          default(FALSE)
#  feature_dam                :boolean          default(FALSE)
#  feature_directory          :boolean          default(FALSE)
#  feature_jobs               :boolean          default(FALSE)
#  feature_posts              :boolean          default(FALSE)
#  has_sso                    :boolean          default(FALSE)
#  host                       :string
#  name                       :string
#  privacy_policy             :text
#  registration_contact       :string
#  sso_button_label           :string
#  sso_cert                   :text
#  sso_mapping                :jsonb
#  sso_name_identifier_format :string
#  sso_provider               :integer          default("saml")
#  sso_target_url             :string
#  terms                      :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  about_id                   :uuid             indexed => [about_type]
#  university_id              :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranets_on_about          (about_type,about_id)
#  index_communication_extranets_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_c2268c7ebd  (university_id => universities.id)
#
require "test_helper"

class Communication::ExtranetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
