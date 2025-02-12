module Communication::Website::Permalink::WithMapping
  extend ActiveSupport::Concern

  included do
    MAPPING = {
      "Administration::Location::Localization" => Communication::Website::Permalink::Location,
      "Communication::Website::Agenda::Event::Localization" => Communication::Website::Permalink::Agenda::Event,
      "Communication::Website::Agenda::Exhibition::Localization" => Communication::Website::Permalink::Agenda::Exhibition,
      "Communication::Website::Agenda::Category::Localization" => Communication::Website::Permalink::Agenda::Category,
      "Communication::Website::Page::Category::Localization" => Communication::Website::Permalink::Page::Category,
      "Communication::Website::Page::Localization" => Communication::Website::Permalink::Page,
      "Communication::Website::Portfolio::Project::Localization" => Communication::Website::Permalink::Portfolio::Project,
      "Communication::Website::Portfolio::Category::Localization" => Communication::Website::Permalink::Portfolio::Category,
      "Communication::Website::Post::Localization" => Communication::Website::Permalink::Post,
      "Communication::Website::Post::Category::Localization" => Communication::Website::Permalink::Category,
      "Education::Diploma::Localization" => Communication::Website::Permalink::Diploma,
      "Education::Program::Category::Localization" => Communication::Website::Permalink::Program::Category,
      "Education::Program::Localization" => Communication::Website::Permalink::Program,
      "Research::Journal::Paper::Localization" => Communication::Website::Permalink::Paper,
      "Research::Journal::Volume::Localization" => Communication::Website::Permalink::Volume,
      "Research::Publication" => Communication::Website::Permalink::Publication,
      "University::Organization::Localization" => Communication::Website::Permalink::Organization,
      "University::Organization::Category::Localization" => Communication::Website::Permalink::Organization::Category,
      "University::Person::Localization" => Communication::Website::Permalink::Person,
      "University::Person::Category::Localization" => Communication::Website::Permalink::Person::Category,
      "University::Person::Localization::Administrator" => Communication::Website::Permalink::Administrator,
      "University::Person::Localization::Author" => Communication::Website::Permalink::Author,
      "University::Person::Localization::Researcher" => Communication::Website::Permalink::Researcher,
      "University::Person::Localization::Teacher" => Communication::Website::Permalink::Teacher
    }

    def self.for_object(object, website)
      lookup_key = self.lookup_key_for_object(object)
      permalink_class = MAPPING[lookup_key]
      raise ArgumentError.new("Permalinks do not handle an object of type #{object.class.to_s}") if permalink_class.nil?
      permalink_class.new(website: website, about: object)
    end

    def self.supported_by?(object)
      lookup_key = self.lookup_key_for_object(object)
      MAPPING.keys.include?(lookup_key)
    end

    def self.lookup_key_for_object(object)
      object.class.to_s
    end

    protected

    def self.required_kinds_in_website(website)
      MAPPING.values.select { |permalink_class|
        permalink_class.required_in_config?(website)
      }
    end
  end
end
