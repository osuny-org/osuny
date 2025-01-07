# == Schema Information
#
# Table name: communication_media_categories
#
#  id            :uuid             not null, primary key
#  is_taxonomy   :boolean          default(FALSE)
#  position      :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_media_categories_on_parent_id      (parent_id)
#  index_communication_media_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_0a4c8a02ba  (parent_id => communication_media_categories.id)
#  fk_rails_38ffe8784a  (university_id => universities.id)
#
class Communication::Media::Category < ApplicationRecord
  include AsCategory
  include Localizable
  include WithUniversity

  has_and_belongs_to_many :communication_medias,
                          class_name: 'Communication::Media',
                          join_table: :communication_media_categories_medias,
                          foreign_key: :communication_media_category_id,
                          association_foreign_key: :communication_media_id
  alias                   :medias :communication_medias
end
