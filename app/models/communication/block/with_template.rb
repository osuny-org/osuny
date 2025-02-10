module Communication::Block::WithTemplate
  extend ActiveSupport::Concern

  included do
    OPTION_PREFIX = 'option_'.freeze

    # Les numéros sont un peu en vrac
    # Dans l'idée, pour le futur
    # 1000 basic
    # 2000 storytelling
    # 3000 references
    # 4000 utilities
    enum :template_kind, {
      agenda: 3100,
      call_to_action: 900,
      categories: 3500,
      chapter: 50,
      contact: 57,
      datatable: 54,
      definitions: 800,
      embed: 53,
      features: 2010,
      files: 55,
      gallery: 300,
      image: 51,
      key_figures: 56,
      license: 4040,
      links: 4050,
      locations: 3200,
      organizations: 200,
      pages: 600,
      papers: 3300,
      persons: 100,
      posts: 500,
      projects: 3101,
      programs: 58,
      sound: 1005,
      testimonials: 400,
      timeline: 700,
      title: 1001,
      video: 52,
      volumes: 3310
    }, prefix: :template

    # Used to purge images when unattaching them
    # template_blobs would be a better name, because there are files
    has_many_attached :template_images

    before_save :attach_template_blobs
  end

  def template
    @template ||= template_class.new self, self.attributes['data']
  end

  def template_reset!
    @template = nil
  end

  def options
    options = {}
    template.components_descriptions.map do |desc|
      property = desc[:property].to_s
      next unless property.start_with?(OPTION_PREFIX)
      property_without_prefix = property.remove(OPTION_PREFIX)
      options[property_without_prefix] = template.public_send(property)
    end
    options
  end

  protected

  def template_class
    "Communication::Block::Template::#{template_kind.classify}".constantize
  end

  # FIXME @sebou
  # Could not find or build blob: expected attachable, got #<ActiveStorage::Blob id: "f4c78657-5062-416b-806f-0b80fb66f9cd", key: "gri33wtop0igur8w3a646llel3sd", filename: "logo.svg", content_type: "image/svg+xml", metadata: {"identified"=>true, "width"=>709, "height"=>137, "analyzed"=>true}, service_name: "scaleway", byte_size: 4137, checksum: "aZqqTYabP5+72ZeddcZ/2Q==", created_at: "2022-05-05 12:17:33.941505000 +0200", university_id: "ebf2d273-ffc9-4d9f-a4ee-a2146913d617">
  def attach_template_blobs
    # self.template_images = template.active_storage_blobs
  end

end
