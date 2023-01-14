# == Schema Information
#
# Table name: university_people
#
#  id                    :uuid             not null, primary key
#  address               :string
#  biography             :text
#  birthdate             :date
#  city                  :string
#  country               :string
#  email                 :string
#  first_name            :string
#  gender                :integer
#  habilitation          :boolean          default(FALSE)
#  hal_doc_identifier    :string
#  hal_form_identifier   :string
#  hal_person_identifier :string
#  is_administration     :boolean
#  is_alumnus            :boolean          default(FALSE)
#  is_author             :boolean
#  is_researcher         :boolean
#  is_teacher            :boolean
#  last_name             :string
#  linkedin              :string
#  meta_description      :text
#  name                  :string
#  phone_mobile          :string
#  phone_personal        :string
#  phone_professional    :string
#  slug                  :string
#  summary               :text
#  tenure                :boolean          default(FALSE)
#  twitter               :string
#  url                   :string
#  zipcode               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  university_id         :uuid             not null, indexed
#  user_id               :uuid             indexed
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_b47a769440  (user_id => users.id)
#  fk_rails_da35e70d61  (university_id => universities.id)
#
class University::Person::Author < University::Person
  def self.polymorphic_name
    'University::Person::Author'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}authors/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/authors/static"
  end

  def for_website?(website)
    website.has_authors? && website.authors.pluck(:id).include?(self.id)
  end
end
