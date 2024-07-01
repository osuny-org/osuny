# == Schema Information
#
# Table name: university_organization_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  position      :integer          default(0)
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :uuid             not null, indexed
#  original_id   :uuid             indexed
#  parent_id     :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_categories_on_language_id    (language_id)
#  index_university_organization_categories_on_original_id    (original_id)
#  index_university_organization_categories_on_parent_id      (parent_id)
#  index_university_organization_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_37ae779dce  (language_id => languages.id)
#  fk_rails_cac868da9e  (original_id => university_organization_categories.id)
#  fk_rails_e24342b62d  (parent_id => university_organization_categories.id)
#  fk_rails_f610c7eb13  (university_id => universities.id)
#
class University::Organization::Category < ApplicationRecord
  include AsIndirectObject
  include Contentful
  include Initials
  include Permalinkable
  include Sluggable
  include Localizable
  include WithGitFiles
  include WithPosition
  include WithTree
  include WithUniversity

  belongs_to :parent,
             class_name: 'University::Organization::Category',
             optional: true
  has_many   :children,
             class_name: 'University::Organization::Category',
             foreign_key: :parent_id,
             dependent: :destroy
  has_and_belongs_to_many :organizations,
                          class_name: 'University::Organization',
                          join_table: :university_organizations_categories

  validates :name, presence: true

  def git_path(website)
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "organizations_categories/#{slug}/_index.html"
  end

  def template_static
    "admin/university/organizations/categories/static"
  end

  def to_s
    "#{name}"
  end

  def dependencies
    contents_dependencies
  end

  def references
    organizations
  end

end
