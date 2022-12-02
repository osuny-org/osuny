module WithWebsitePermalink
  extend ActiveSupport::Concern

  included do

    def permalink_in_website(website)
      computed_permalink = computed_permalink_in_website(website)
      computed_permalink.present? ? Static.clean_path(computed_permalink) : nil
    end

    def previous_permalink_in_website(website)
      computed_permalink = previous_computed_permalink_in_website(website)
      computed_permalink.present? ? Static.clean_path(computed_permalink) : nil
    end

    def computed_permalink_in_website(website)
      raw_permalink_in_website(website)&.gsub(':slug', self.slug)
    end

    def previous_computed_permalink_in_website(website)
      raw_permalink_in_website(website)&.gsub(':slug', self.slug_was)
    end

    protected

    def raw_permalink_in_website(website)
      website.config_permalinks.permalinks_data[permalink_config_key]
    end

    def permalink_config_key
      raise NotImplementedError
    end

  end
end
