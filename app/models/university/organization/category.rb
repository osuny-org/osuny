# == Schema Information
#
# Table name: university_organization_categories
#
#  id                   :uuid             not null, primary key
#  is_taxonomy          :boolean          default(FALSE)
#  migration_identifier :string
#  position             :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  parent_id            :uuid             indexed
#  university_id        :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_categories_on_parent_id      (parent_id)
#  index_university_organization_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_e24342b62d  (parent_id => university_organization_categories.id)
#  fk_rails_f610c7eb13  (university_id => universities.id)
#
class University::Organization::Category < ApplicationRecord
  include AsCategory
  include AsIndirectObject
  include Localizable
  include WithOpenApi
  include WithUniversity

  has_and_belongs_to_many :organizations
  alias                   :category_objects :organizations

  def dependencies
    super +
    localizations +
    [website.config_default_content_security_policy]
  end

  def references
    organizations
  end

end
