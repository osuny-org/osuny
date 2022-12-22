class Communication::Block::Template::Chapter < Communication::Block::Template::Base

  has_layouts [:no_background, :alt_background, :accent_background]

  has_component :text, :rich_text
  has_component :notes, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end
end
