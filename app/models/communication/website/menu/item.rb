# == Schema Information
#
# Table name: communication_website_menu_items
#
#  id            :uuid             not null, primary key
#  about_type    :string
#  kind          :integer          default("blank")
#  position      :integer
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid
#  menu_id       :uuid             not null
#  parent_id     :uuid
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_menu_items_on_about          (about_type,about_id)
#  index_communication_website_menu_items_on_menu_id        (menu_id)
#  index_communication_website_menu_items_on_parent_id      (parent_id)
#  index_communication_website_menu_items_on_university_id  (university_id)
#  index_communication_website_menu_items_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (menu_id => communication_website_menus.id)
#  fk_rails_...  (parent_id => communication_website_menu_items.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::Menu::Item < ApplicationRecord
  include WithTree

  attr_accessor :skip_publication_callback

  belongs_to :university
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :menu, class_name: 'Communication::Website::Menu'
  belongs_to :parent, class_name: 'Communication::Website::Menu::Item', optional: true
  belongs_to :about, polymorphic: true, optional: true
  has_many :children,
           class_name: 'Communication::Website::Menu::Item',
           foreign_key: :parent_id,
           dependent: :destroy

  enum kind: {
    blank: 0,
    url: 10,
    page: 20,
    programs: 30,
    program: 31,
    news: 40,
    news_category: 41,
    news_article: 42,
    staff: 50
  }, _prefix: :kind

  validates :title, presence: true
  validates :about, presence: true, if: :has_about?

  before_create :set_position
  after_commit :sync_menu

  scope :ordered, -> { order(position: :asc) }

  def to_s
    "#{title}"
  end

  def static_target
    target = ''
    case self.kind
    when 'url'
      target = url
    when 'programs'
      target = "/#{website.programs_github_directory}"
    when 'program'
      target = "/#{website.programs_github_directory}#{about.path}"
    when 'news'
      target = "/#{website.posts_github_directory}"
    when 'staff'
      target = "/#{website.staff_github_directory}"
    when 'blank'
      target = ''
    else
      target = about&.path
    end
    target.end_with?('/') ? target
                          : "#{target}/"
  end

  def list_of_other_items
    items = []
    menu.items.where.not(id: id).root.ordered.each do |item|
      items.concat(item.self_and_children(0))
    end
    items.reject! { |p| p[:id] == id }
    items
  end

  def to_static_hash
    return {} if kind_news_article? && !about.published
    {
      'title' => title,
      'target' => static_target,
      'kind' => kind,
      'children' => children.ordered.map(&:to_static_hash)
    }
  end

  def has_about?
    kind_page? || kind_program? || kind_news_category? || kind_news_article?
  end

  def sync_menu
    menu.sync_with_git
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def set_position
    last_element = menu.items.where(parent_id: parent_id).ordered.last
    self.position = last_element.nil? ? 1
                                      : last_element.position + 1
  end
end
