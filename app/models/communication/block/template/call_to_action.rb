class Communication::Block::Template::CallToAction < Communication::Block::Template::Base

  has_layouts [
    :accent_background,
    :no_background
  ]

  has_elements
  has_component :text, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  def top_description
    text
  end

  def media_blobs
    return [] unless image_component.blob.present?
    [
      {
        blob: image_component.blob,
        alt: alt,
        credit: credit
      }
    ]
  end

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

end
