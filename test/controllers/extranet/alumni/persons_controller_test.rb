require "test_helper"

class Extranet::Alumni::PersonsControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_index
    get alumni_university_persons_path(lang: french)
    assert_response(:success)
  end

  def test_show
    get alumni_university_person_path(university_people(:alumnus), lang: french)
    assert_response(:success)
  end
end
