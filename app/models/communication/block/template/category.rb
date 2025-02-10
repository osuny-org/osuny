class Communication::Block::Template::Category < Communication::Block::Template::Base

  has_layouts [
    :grid,
    :list,
    :cards,
    :alternate,
    :large
  ]
  has_component :category_kind, :option, options: (
    Communication::Block::CATEGORIES[:references] - [
      :categories,
      :locations,
      :papers,
      :volumes,
    ]
  )
  has_component :taxonomy_id, :taxonomy
  has_component :description, :rich_text

  has_component :option_count,        :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_summary,      :boolean, default: true

  def allowed_for_about?
    !website.nil?
  end

  # All the categories for the chosen kind
  def available_categories
    categories_for(category_kind)
  end

  def categories_for(category_kind)
    case category_kind.to_sym
    when :agenda
      website&.agenda_categories
    when :locations
      # No category yet
    when :organizations
      university.organization_categories
    when :papers
      # No category yet
    when :pages
      website&.page_categories
    when :persons
      university.person_categories
    when :posts
      website&.post_categories
    when :programs
      university.education_program_categories
    when :projects
      website&.portfolio_categories
    when :volumes
      # No category yet
    end
  end

  def taxonomies_for(category_kind)
    categories_for(category_kind)&.taxonomies.ordered(language)
  end

  def category_kinds_allowed
    @category_kinds_allowed = []
    category_kind_component.options.each do |kind|
      b = Communication::Block.new
      b.template_kind = kind
      b.about = about
      next unless b.template.allowed_for_about?
      @category_kinds_allowed << kind
    end
    @category_kinds_allowed
  end

  def selected_categories
    return [] if category_kind.nil?
    if taxonomy.present?
      selected_categories_from_taxonomy
    else
      selected_categories_free
    end
  end

  def taxonomy
    taxonomy_id_component.taxonomy
  end

  protected

  def selected_categories_from_taxonomy
    only_categories_used(taxonomy.children.ordered(language))
  end

  def selected_categories_free
    only_categories_used(available_categories.out_of_taxonomy.ordered(language))
  end

  def only_categories_used(categories)
    categories.reject { |category| category.count_objects_in(block.language, website).zero? }
  end
end