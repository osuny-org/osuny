class Communication::Block::Template::Person::Element < Communication::Block::Template::Base

  has_component :id, :person
  has_component :role, :string

  def person
    id_component.person
  end

  def person_id
    id_component.data
  end
end
