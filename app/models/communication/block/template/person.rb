class Communication::Block::Template::Person < Communication::Block::Template::Base

  has_elements
  has_component :mode, :option, options: [
    :selection,
    :category
  ]
  has_component :category_id, :person_category
  has_component :description, :rich_text
  has_component :alphabetical, :boolean

  has_component :option_image,        :boolean, default: true
  has_component :option_summary,      :boolean, default: true
  has_component :option_link,         :boolean, default: true

  def elements
    if alphabetical
      @elements.sort_by! do |element|
        "#{element.person&.to_s_alphabetical_in(block.language)}"
      end
    end
    @elements
  end

  def dependencies
    persons
  end

  def selected_elements
    @selected_elements ||= send "selected_elements_#{mode}"
  end

  def persons
    @persons ||= selected_elements.collect(&:person).compact.uniq
  end
  alias :people :persons

  def person_ids
    @person_ids ||= persons.collect(&:id)
  end

  def children
    persons
  end

  def children_ids
    person_ids
  end

  protected

  def selected_elements_selection
    elements
  end

  def selected_elements_category
    return [] if category.nil?
    persons = university.university_people
                        .for_category(category.id)
                        .ordered(block.language)
    persons.map do |person|
      # On simule un élément pour la personne, afin d'unifier les accès
      Communication::Block::Template::Person::Element.new(block, {
        'id' => person.id
      })
    end
  end

  def category
    category_id_component.category
  end
end
