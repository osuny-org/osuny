class Communication::Block::Template::Page < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :cards,
    :alternate,
    :large
  ]
  has_component :mode, :option, options: [
    :selection,
    :children,
    :category
  ]
  has_component :text, :rich_text # Deprecated
  has_component :page_id, :page
  has_component :category_id, :page_category

  has_component :option_image,        :boolean, default: true
  has_component :option_main_summary, :boolean, default: true # Deprecated
  has_component :option_summary,      :boolean, default: true
  
  def page
    page_id_component.page
  end

  def category
    category_id_component.category
  end

  def dependencies
    selected_pages
  end

  def selected_pages
    @selected_pages ||= send "selected_pages_#{mode}"
  end

  def allowed_for_about?
    !website.nil?
  end

  def children
    selected_pages
  end

  def top_title
    block.title.presence || page_l10n.to_s
  end

  def top_description
    page_l10n.try(:summary) if option_main_summary
  end

  def top_link
    return if page_l10n.nil?
    page_l10n.hugo(website).permalink
  end

  protected

  def page_l10n
    return nil if page.nil?
    l10n = page.localization_for(language)
    return nil if l10n.draft?
    l10n
  end

  def selected_pages_selection
    elements.map { |element| element.page }.compact
  end

  def selected_pages_children
    return [] unless page
    page.children
        .published_now_in(block.language)
        .ordered
  end

  def selected_pages_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten

    block.about&.website
                .pages
                .published_now_in(block.language)
                .for_category(category_ids)
                .ordered(block.language)
  end

end
