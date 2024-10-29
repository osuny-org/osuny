class Communication::Block::Template::Testimonial::Element < Communication::Block::Template::Base

  has_component :text, :rich_text
  has_component :author, :string
  has_component :job, :string
  has_component :photo, :image

end
