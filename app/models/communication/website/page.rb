# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  design_options           :jsonb
#  full_width               :boolean          default(FALSE)
#  migration_identifier     :string
#  position                 :integer          default(0), not null
#  type                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1a42003f06  (parent_id => communication_website_pages.id)
#  fk_rails_280107c62b  (communication_website_id => communication_websites.id)
#  fk_rails_d208d15a73  (university_id => universities.id)
#

class Communication::Website::Page < ApplicationRecord
  # FIXME: Remove legacy column from db
  # kind was replaced by type in January 2023
  self.ignored_columns = %w(path kind)

  include AsDirectObject
  include Duplicable
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include Localizable
  include Orderable
  include Sanitizable
  include Searchable
  include WithAutomaticMenus
  include WithDesignOptions
  include WithMenuItemTarget
  include WithOpenApi
  include WithSpecialPage # WithSpecialPage can set default publication status, so must be included before WithPublication
  include WithTree
  include WithUniversity

  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  has_many   :children,
             class_name: 'Communication::Website::Page',
             foreign_key: :parent_id,
             dependent: :destroy

  after_save :touch_elements_if_special_page_in_hierarchy

  scope :latest_in, -> (language) { published_now_in(language).order("communication_website_page_localizations.updated_at DESC").limit(5) }

  scope :ordered_by_title, -> (language) {
    localization_title_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.title))) END),
        MAX(TRIM(LOWER(UNACCENT(localizations.title)))) FILTER (WHERE localizations.rank = 1)
      ) AS localization_title
    SQL

    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          communication_website_page_localizations as localizations
      ) localizations ON communication_website_pages.id = localizations.about_id
    SQL
    ]))
    .select("communication_website_pages.*", localization_title_select)
    .group("communication_website_pages.id")
    .order("localization_title ASC")
  }

  scope :for_search_term, -> (term, language) {
     joins(:localizations)
      .where(communication_website_page_localizations: { language_id: language.id })
      .where("
        unaccent(communication_website_page_localizations.meta_description) ILIKE unaccent(:term) OR
        unaccent(communication_website_page_localizations.summary) ILIKE unaccent(:term) OR
        unaccent(communication_website_page_localizations.title) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }

  scope :for_published, -> (published, language) {
    joins(:localizations)
      .where(communication_website_page_localizations: { language_id: language.id , published: published == 'true'})
  }
  scope :for_full_width, -> (full_width, language = nil) { where(full_width: full_width == 'true') }

  def dependencies
    localizations.in_languages(website.active_language_ids) +
    categories
  end

  def references
    [parent] +
    siblings +
    website.menus.in_languages(website.active_language_ids) +
    abouts_with_page_block
  end

  # Pages do have a category, but we do not list all the existing pages categories
  def special_page_categories
    false
  end

  def siblings
    self.class.unscoped
              .where(parent: parent, university: university, website: website)
              .where.not(id: id)
  end

  # Some special pages can override this method to allow explicit direct connections
  # Example: The Communication::Website::Page::Person special page allows to connect University::Person records directly.
  def self.direct_connection_permitted_about_class
    nil
  end

  protected

  def last_ordered_element
    website.pages.where(parent_id: parent_id).ordered.last
  end

  def abouts_with_page_block
    website.blocks.template_pages.collect(&:about)
  end

  def touch_elements_if_special_page_in_hierarchy
    # We do not call touch as we don't want to trigger the sync on the connected objects
    descendants_and_self.each do |page|
      if page.type == 'Communication::Website::Page::Person'
        website.connected_people.update_all(updated_at: Time.zone.now)
      elsif page.type == 'Communication::Website::Page::Organization'
        website.connected_organizations.update_all(updated_at: Time.zone.now)
      end
    end
  end
end
