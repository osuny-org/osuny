module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def special_page(type)
    page = find_special_page(type)
    page ||= create_default_special_page(type)
    page
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |type|
      page = special_page(type)
      page.create_missing_localizations! if page
    end
  end

  protected

  def find_special_page(type)
    pages.tmp_original # TODO L10N : To remove
         .where(type: type.to_s)
         .first
  end

  def create_default_special_page(type)
    # Special pages have a before_validation (:on_create) callback to preset the original localization (title, slug, ...)
    page = pages.where(type: type.to_s, university_id: university_id).first_or_initialize
    # Ignore useless pages (not in this website)
    return unless page.is_necessary_for_website?
    page.save_and_sync
    page
  end

end
