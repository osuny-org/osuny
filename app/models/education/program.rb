# == Schema Information
#
# Table name: education_programs
#
#  id                 :uuid             not null, primary key
#  capacity           :integer
#  continuing         :boolean
#  description        :text
#  ects               :integer
#  featured_image_alt :string
#  level              :integer
#  name               :string
#  path               :string
#  position           :integer          default(0)
#  published          :boolean          default(FALSE)
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_id          :uuid
#  university_id      :uuid             not null
#
# Indexes
#
#  index_education_programs_on_parent_id      (parent_id)
#  index_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => education_programs.id)
#  fk_rails_...  (university_id => universities.id)
#
class Education::Program < ApplicationRecord
  include WithGit
  include WithMedia
  include WithMenuItemTarget
  include WithSlug
  include WithTree
  include WithInheritance

  rich_text_areas_with_inheritance  :accessibility,
                                    :contacts,
                                    :duration,
                                    :evaluation,
                                    :objectives,
                                    :opportunities,
                                    :other,
                                    :pedagogy,
                                    :prerequisites,
                                    :pricing,
                                    :registration

  attr_accessor :skip_websites_categories_callback

  has_one_attached_deletable :featured_image

  belongs_to :university
  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true
  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id,
             dependent: :destroy
  has_many   :members,
             class_name: 'Education::Program::Member',
             dependent: :destroy,
             inverse_of: :program
  has_and_belongs_to_many :schools,
                          class_name: 'Education::School',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_program_id',
                          association_foreign_key: 'education_school_id'
  has_and_belongs_to_many :teachers,
                          class_name: 'Administration::Member',
                          join_table: 'education_programs_teachers',
                          foreign_key: 'education_program_id',
                          association_foreign_key: 'education_teacher_id'
  has_many :websites, -> { distinct }, through: :schools

  accepts_nested_attributes_for :members, allow_destroy: true

  enum level: {
    first_year: 100,
    second_year: 200,
    dut: 210,
    bachelor: 300,
    master: 500,
    doctor: 800
  }

  validates_presence_of :name

  after_save :update_children_paths, if: :saved_change_to_path?
  after_save_commit :set_websites_categories, unless: :skip_websites_categories_callback

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:position) }

  def to_s
    "#{name}"
  end

  def best_featured_image(fallback: true)
    return featured_image if featured_image.attached?
    best_image = parent&.best_featured_image(fallback: false)
    best_image ||= featured_image if fallback
    best_image
  end

  def git_path_static
    "content/programs/#{path}/_index.html".gsub(/\/+/, '/')
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  def set_websites_categories
    websites.find_each(&:set_programs_categories!)
  end
end
