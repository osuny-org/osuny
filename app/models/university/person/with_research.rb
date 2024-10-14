module University::Person::WithResearch
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :research_hal_authors,
                            class_name: 'Research::Hal::Author',
                            foreign_key: :university_person_id,
                            association_foreign_key: :research_hal_author_id
                            alias :hal_authors :research_hal_authors

    has_many                :authored_research_theses,
                            class_name: 'Research::Thesis',
                            foreign_key: :author_id,
                            dependent: :destroy

    has_many                :directed_research_theses,
                            class_name: 'Research::Thesis',
                            foreign_key: :director_id,
                            dependent: :nullify

    has_and_belongs_to_many :research_publications,
                            class_name: 'Research::Publication',
                            foreign_key: :university_person_id,
                            association_foreign_key: :research_publication_id
                            alias :publications :research_publications

    has_and_belongs_to_many :research_laboratories,
                            class_name: 'Research::Laboratory',
                            foreign_key: :university_person_id,
                            association_foreign_key: :research_laboratory_id
                            alias :laboratories :research_laboratories

    scope :with_hal_identifier, -> { where.not(hal_form_identifier: [nil,'']) }
  end

  # Import HAL publications by retrieving them from API
  def import_research_hal_publications!
    publications.delete(publications.hal)
    hal_authors.each do |author|
      # TODO manage same researcher in different universities
      publications.concat author.import_research_hal_publications!
    end
  end

  # Connect HAL publications from HAL authors without calling the API
  def connect_research_hal_publications!
    publications.delete(publications.hal)
    hal_authors.each do |author|
      # TODO manage same researcher in different universities
      publications.concat author.publications
    end
  end

end
