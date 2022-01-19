# == Schema Information
#
# Table name: research_journal_volumes
#
#  id                  :uuid             not null, primary key
#  description         :text
#  featured_image_alt  :string
#  keywords            :text
#  number              :integer
#  published           :boolean          default(FALSE)
#  published_at        :date
#  slug                :string
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  research_journal_id :uuid             not null
#  university_id       :uuid             not null
#
# Indexes
#
#  index_research_journal_volumes_on_research_journal_id  (research_journal_id)
#  index_research_journal_volumes_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_journal_id => research_journals.id)
#  fk_rails_...  (university_id => universities.id)
#
class Research::Journal::Volume < ApplicationRecord
  include WithGit
  include WithFeaturedImage
  include WithBlobs

  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  has_many :articles, foreign_key: :research_journal_volume_id, dependent: :nullify
  has_many :websites, -> { distinct }, through: :journal
  has_many :researchers, through: :articles

  before_validation :set_published_at, if: :published_changed?

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(number: :desc, published_at: :desc) }

  def website
    journal.website
  end

  def git_path(website)
    "content/volumes/#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}.html" if published_at
  end

  def git_dependencies(website)
    [self] + articles + researchers + researchers.map(&:researcher) + active_storage_blobs
  end

  def git_destroy_dependencies(website)
    [self] + active_storage_blobs
  end

  def path
    "/#{published_at&.year}/#{slug}" if published_at
  end

  def to_s
    "##{ number } #{ title }"
  end

  protected

  def set_published_at
    self.published_at = published? ? Time.zone.now : nil
  end

  def explicit_blob_ids
    [featured_image&.blob_id, rich_text_blob_ids]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
