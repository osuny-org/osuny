class Communication::Block::Template::Program < Communication::Block::Template::Base

  has_elements

  def dependencies
    selected_programs
  end

  def selected_programs
    @selected_programs ||= elements.map { |element| element.program }.compact
  end

  def allowed_for_about?
    !website.nil?
  end

  def available_programs
    website.education_programs
  end
end
