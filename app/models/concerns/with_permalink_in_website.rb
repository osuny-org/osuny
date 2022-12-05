module WithPermalinkInWebsite
  extend ActiveSupport::Concern

  included do

    has_many  :permalinks,
              class_name: "Communication::Website::Permalink",
              as: :about,
              dependent: :destroy

    after_validation :manage_permalinks, on: [:create, :update]

  end

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

  def manage_permalinks
    websites_for_self.each do |website|
      old_permalink = previous_permalink_in_website(website)
      new_permalink = permalink_in_website(website)

      # If the object had a permalink and now is different, we create a previous link
      permalinks.create(website: website, path: old_permalink) if old_permalink.present? && new_permalink != old_permalink
    end
  end

  protected

  def raw_permalink_in_website(website)
    website.config_permalinks.permalinks_data[permalink_config_key]
  end

  def permalink_config_key
    raise NotImplementedError
  end
end
