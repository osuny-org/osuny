class Communication::Website::SetProgramsCategoriesJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.set_programs_categories_safely
  end
end
