# == Schema Information
#
# Table name: university_person_categories
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
#  index_university_person_categories_on_language_id    (language_id)
#  index_university_person_categories_on_original_id    (original_id)
#  index_university_person_categories_on_parent_id      (parent_id)
#  index_university_person_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_134ac9c0b6  (university_id => universities.id)
#  fk_rails_23a47d0d6d  (original_id => university_person_categories.id)
#  fk_rails_4c00a79930  (parent_id => university_person_categories.id)
#  fk_rails_7f42ee5643  (language_id => languages.id)
#
class University::Person::Category < ApplicationRecord
  include AsIndirectObject
  include Contentful
  include Initials
  include Permalinkable
  include Sluggable
  include Translatable
  include WithGitFiles
  include WithPosition
  include WithTree
  include WithUniversity

  belongs_to :parent,
             class_name: 'University::Person::Category',
             optional: true
  has_many   :children,
             class_name: 'University::Person::Category',
             foreign_key: :parent_id,
             dependent: :destroy
  has_and_belongs_to_many :people,
                          class_name: 'University::Person',
                          join_table: :university_people_categories

  validates :name, presence: true

  def git_path(website)
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "persons_categories/#{slug}/_index.html"
  end

  def template_static
    "admin/university/people/categories/static"
  end

  def to_s
    "#{name}"
  end

  def dependencies
    contents_dependencies
  end

  def references
    people
  end


end
