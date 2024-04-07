# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  is_current    :boolean          default(TRUE)
#  path          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_permalinks_on_about          (about_type,about_id)
#  index_communication_website_permalinks_on_university_id  (university_id)
#  index_communication_website_permalinks_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink < ApplicationRecord
  MAPPING = {
    "Communication::Website::Page" => Communication::Website::Permalink::Page,
    "Communication::Website::Post" => Communication::Website::Permalink::Post,
    "Communication::Website::Post::Category" => Communication::Website::Permalink::Category,
    "Communication::Website::Agenda::Event" => Communication::Website::Permalink::Agenda::Event,
    "Communication::Website::Agenda::Category" => Communication::Website::Permalink::Agenda::Category,
    "Communication::Website::Portfolio::Project" => Communication::Website::Permalink::Portfolio::Project,
    "Communication::Website::Portfolio::Category" => Communication::Website::Permalink::Portfolio::Category,
    "Administration::Location" => Communication::Website::Permalink::Location,
    "Education::Diploma" => Communication::Website::Permalink::Diploma,
    "Education::Program" => Communication::Website::Permalink::Program,
    "Research::Journal::Paper" => Communication::Website::Permalink::Paper,
    "Research::Journal::Volume" => Communication::Website::Permalink::Volume,
    "Research::Publication" => Communication::Website::Permalink::Publication,
    "University::Organization" => Communication::Website::Permalink::Organization,
    "University::Person" => Communication::Website::Permalink::Person,
    "University::Person::Administrator" => Communication::Website::Permalink::Administrator,
    "University::Person::Author" => Communication::Website::Permalink::Author,
    "University::Person::Researcher" => Communication::Website::Permalink::Researcher,
    "University::Person::Teacher" => Communication::Website::Permalink::Teacher
  }

  attr_accessor :force_sync_about

  # We don't include Sanitizable as this model is never handled by users directly.
  include WithUniversity

  belongs_to :university
  belongs_to :website, class_name: "Communication::Website"
  belongs_to :about, polymorphic: true

  validates :about_id, :about_type, :path, presence: true

  before_validation :set_university, on: :create
  # We should not sync the about object whenever we do something with the permalink, as they can be changed during a sync.
  # so we have an attribute accessor to force-sync the about, for example in the WithPermalink concern
  after_commit :sync_about, on: [:create, :destroy], if: :force_sync_about

  scope :for_website, -> (website) { where(website_id: website.id) }
  scope :current, -> { where(is_current: true) }
  scope :not_current, -> { where(is_current: false) }
  scope :not_root, -> { where.not(path: '/') }

  def self.config_in_website(website, language)
    required_kinds_in_website(website).map { |permalink_class|
      [permalink_class.static_config_key, permalink_class.pattern_in_website(website, language)]
    }.to_h
  end

  def self.for_object(object, website)
    lookup_key = self.lookup_key_for_object(object)
    permalink_class = MAPPING[lookup_key]
    raise ArgumentError.new("Permalinks do not handle an object of type #{object.class.to_s}") if permalink_class.nil?
    permalink_class.new(website: website, about: object)
  end

  # Can be overwritten
  def self.required_in_config?(website)
    false
  end

  def self.lookup_key_for_object(object)
    lookup_key = object.class.to_s
    # Special pages are defined as STI classes (e.g. Communication::Website::Page::Home) but permalinks are handled the same way.
    lookup_key = "Communication::Website::Page" if lookup_key.starts_with?("Communication::Website::Page")
    lookup_key
  end

  def self.supported_by?(object)
    lookup_key = self.lookup_key_for_object(object)
    MAPPING.keys.include?(lookup_key)
  end

  def self.pattern_in_website(website, language)
    raise NotImplementedError
  end

  def self.clean_path(path)
    clean_path = path.dup
    # Remove eventual host
    clean_path = URI(clean_path).path
    # Leading slash for absolute path
    clean_path = "/#{clean_path}" unless clean_path.start_with?('/')
    # Trailing slash for coherence
    clean_path = "#{clean_path}/" unless clean_path.end_with?('/')
    clean_path
  rescue URI::InvalidURIError
    nil
  end

  def self.permitted_about_types
    ApplicationRecord.model_names_with_concern(WithPermalink)
  end

  def pattern
    language = about.respond_to?(:language) ? about.language : website.default_language
    self.class.pattern_in_website(website, language)
  end

  def computed_path
    return @computed_path if defined?(@computed_path)
    @computed_path ||= published? ? Static.clean_path(published_path) : nil
  end

  def save_if_needed
    current_permalink = about.current_permalink_in_website(website)

    return unless computed_path.present? && (current_permalink.nil? || current_permalink.path != computed_path)

    # If the object had no permalink or if its path changed, we create a new permalink and delete old with same path
    existing_permalinks_for_path = self.class.unscoped.where(website_id: website_id, about_id: about_id, about_type: about_type, path: computed_path, is_current: false)
    self.path = computed_path
    if save
      existing_permalinks_for_path.find_each(&:destroy)
      current_permalink&.update(is_current: false)
    end
  end

  def to_s
    "#{path}"
  end

  protected

  def self.required_kinds_in_website(website)
    MAPPING.values.select { |permalink_class|
      permalink_class.required_in_config?(website)
    }
  end

  # Can be overwritten (Page for example)
  def published_path
    # TODO I18n doit prendre la langue du about
    language = about.respond_to?(:language) ? about.language : website.default_language
    p = ""
    p += "/#{language.iso_code}" if website.languages.many?
    p += pattern
    substitutions.each do |key, value|
      p.gsub! ":#{key}", "#{value}"
    end
    p
  end

  # Can be overwritten
  def published?
    # TODO probleme si pas for_website?, par exemple pour les objets directs
    about.for_website?(website)
  end

  # Can be overwritten
  def substitutions
    {
      slug: about.slug
    }
  end

  def set_university
    self.university_id = website.university_id
  end

  def sync_about
    return unless about.persisted?
    about.is_direct_object? ? about.sync_with_git : about.touch
  end
end
