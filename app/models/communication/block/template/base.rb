class Communication::Block::Template::Base
  class_attribute :components_descriptions

  attr_reader :block

  def self.has_string(property)
    has_component property, :string
  end

  def self.has_text(property)
    has_component property, :text
  end

  def self.has_rich_text(property)
    has_component property, :rich_text
  end

  def self.has_select(property, **args)
    has_component property, :select
  end

  def self.has_image(property)
    has_component property, :image
    has_component "#{property}_alt".to_sym, :string
    has_component "#{property}_credit".to_sym, :string
  end

  def self.has_component(property, kind)
    self.components_descriptions ||= []
    self.components_descriptions << { name: property, type: kind }
    class_eval <<-CODE, __FILE__, __LINE__ + 1

      def #{property}_component
        @#{property}_component ||= Communication::Block::Component::#{kind.to_s.classify}.new(:#{property}, self)
      end

      def #{property}
        load_data
        #{property}_component.data
      end

      def #{property}=(value)
        load_data
        #{property}_component.data = value
      end

    CODE
  end

  def initialize(block)
    @block = block
    @data_loaded = false
  end

  def data=(value)
    if value.is_a? String
      json = JSON.parse(value)
    elsif value.is_a? Hash
      json = value
    else
      json = default_data
    end
    components.each do |component|
      next unless json.has_key? component.property
      component.data = json[component.property]
    end
  end

  def data
    hash = default_data
    components.each do |component|
      hash[component.property] = component.data
    end
    hash
  end

  def git_dependencies
    unless @git_dependencies
      @git_dependencies = []
      build_git_dependencies
      @git_dependencies.uniq!
    end
    @git_dependencies
  end

  def active_storage_blobs
    []
  end

  def elements
    data['elements']
  end

  def blob_with_id(id)
    university.active_storage_blobs.find id
  end

  def default_data
    {
      'elements' => []
    }
  end

  protected

  def load_data
    return if @data_loaded
    # Accessing the data loads it from database
    block.data
    @data_loaded = true
  end

  def build_git_dependencies
  end

  def add_dependency(dependency)
    if dependency.is_a? Array
      @git_dependencies += dependency
    else
      @git_dependencies += [dependency]
    end
  end

  def find_blob(object, key)
    id = object.dig(key, 'id')
    return if id.blank?
    find_blob id
  end

  def extract_image_alt_and_credit(source, variable)
    blob = find_blob source, variable
    return if blob.nil?
    alt = source["alt"] || source["#{variable}_alt"]
    credit = source["credit"] || source["#{variable}_credit"]
    text = source["text"] || source["#{variable}_text"]
    {
      blob: blob,
      alt: alt,
      credit: credit,
      text: text
    }.to_dot
  end

  def components
    return [] if self.class.components_descriptions.nil?
    self.class.components_descriptions.map do |component_description|
      send "#{component_description[:name]}_component"
    end
  end

  def university
    block.university
  end
end
