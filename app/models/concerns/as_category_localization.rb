module AsCategoryLocalization
  extend ActiveSupport::Concern

  included do
    include AsLocalization
    include AsLocalizedTree
    include Contentful
    include Initials
    include Permalinkable
    include Sanitizable
    include WithBlobs
    include WithFeaturedImage
    include WithGitFiles
    include WithUniversity
  
    has_summernote :summary
  
    validates :name, presence: true
  end

  def to_s
    "#{name}"
  end

  protected

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [featured_image&.blob_id]
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

  def hugo_slug_in_website(website)
    slug_with_ancestors_slugs
  end
end