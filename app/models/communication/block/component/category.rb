# Not used yet, will be used by the Category Template to select specific categories
class Communication::Block::Component::Category < Communication::Block::Component::Base

  def category
    template.available_categories
            .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
