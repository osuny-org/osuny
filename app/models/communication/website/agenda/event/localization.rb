# == Schema Information
#
# Table name: communication_website_agenda_event_localizations
#
#  id                       :uuid             not null, primary key
#  add_to_calendar_urls     :jsonb
#  featured_image_alt       :string
#  featured_image_credit    :text
#  header_cta               :boolean          default(FALSE)
#  header_cta_label         :string
#  header_cta_url           :string
#  meta_description         :string
#  migration_identifier     :string
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string
#  subtitle                 :string
#  summary                  :text
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_db6323806a                  (about_id)
#  idx_on_communication_website_id_87f393a516  (communication_website_id)
#  idx_on_language_id_c00e1d0218               (language_id)
#  idx_on_university_id_eaf79b0514             (university_id)
#
# Foreign Keys
#
#  fk_rails_5b3e0f2f0c  (language_id => languages.id)
#  fk_rails_945cb27530  (about_id => communication_website_agenda_events.id)
#  fk_rails_991b1838ec  (university_id => universities.id)
#  fk_rails_bb85c47fb8  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Event::Localization < ApplicationRecord
  include AsLocalization
  include AsLocalizedTree
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

  alias :event :about

  delegate  :archive?,
            :from_day, :from_hour,
            :to_day, :to_hour,
            :time_zone,
            to: :event

  has_summernote :summary
  has_summernote :text

  validates :title, presence: true
  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    return unless website.id == communication_website_id && published && published_at
    return if event.kind_parent? # Rendered by Communication::Website::Agenda::Event::Day
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    path = "events/"
    path += "archives/#{from_day.year}/" if archive?
    path += "#{from_day.strftime "%Y-%m-%d"}-#{slug}.html"
    path
  end

  def template_static
    "admin/communication/websites/agenda/events/static"
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
