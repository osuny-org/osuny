# Used by the Category template
class Communication::Block::Component::Taxonomy < Communication::Block::Component::Base

  def taxonomy
    template.available_categories
            .find_by(id: data)
  end

  def dependencies
    [taxonomy]
  end

end
