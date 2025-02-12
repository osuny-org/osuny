# == Schema Information
#
# Table name: communication_website_agenda_exhibition_localizations
#
#  id                       :uuid             not null, primary key
#  add_to_calendar_urls     :jsonb
#  featured_image_alt       :string
#  featured_image_credit    :text
#  header_cta               :boolean
#  header_cta_label         :string
#  header_cta_url           :string
#  meta_description         :string
#  migration_identifier     :string
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string
#  subtitle                 :string
#  summary                  :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             not null, indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_a6e772a338                  (about_id)
#  idx_on_communication_website_id_8261badeaa  (communication_website_id)
#  idx_on_language_id_a2de6ce8d0               (language_id)
#  idx_on_university_id_64ba331f7d             (university_id)
#
# Foreign Keys
#
#  fk_rails_2d099939f6  (communication_website_id => communication_websites.id)
#  fk_rails_ee1c77929d  (about_id => communication_website_agenda_exhibitions.id)
#  fk_rails_f684b71a8c  (university_id => universities.id)
#
class Communication::Website::Agenda::Exhibition::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include HeaderCallToAction
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithCal
  include WithFeaturedImage
  include WithGitFiles
  include WithOpenApi
  include WithPublication
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :exhibition :about

  delegate  :archive?,
            :from_day,
            :to_day,
            :time_zone,
            to: :exhibition

  has_summernote :summary

  validates :title, presence: true
  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    return unless website.id == communication_website_id && published && published_at
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    path = "exhibitions/"
    path += "archives/#{from_day.year}/" if archive?
    path += "#{from_day.strftime "%Y-%m-%d"}-#{slug}.html"
    path
  end

  def template_static
    "admin/communication/websites/agenda/exhibitions/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def categories
    about.categories.ordered.map { |category| category.localization_for(language) }.compact
  end

  def to_s
    "#{title}"
  end

  def to_s_with_subtitle
    [title, subtitle].compact_blank.join(' - ')
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

  def localize_other_attachments(localization)
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end
end
