module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def special_page(type, language: default_language)
    page = find_special_page(type, language)
    # If not found, create if default language, else translate
    page ||= language == default_language ? create_default_special_page(type)
                                          : translate_special_page(type, language)
    page
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |page_class|
      # Special pages have a before_validation (:on_create) callback to preset title, slug, ...
      page = page_class.where(website: self, university: university, language_id: default_language_id).first_or_initialize
      next if page.persisted? # No resave
      next unless page.is_necessary_for_website? # No useless pages
      page.save_and_sync
    end
  end

  protected

  def find_special_page(type, language)
    pages.where(type: type.to_s, language_id: language.id).first
  end

  def create_default_special_page(type)
    # Special pages have a before_validation (:on_create) callback to preset title, slug, ...
    page = pages.where(type: type.to_s, language_id: default_language_id, university_id: university_id).first_or_initialize
    page.save_and_sync
    page
  end

  def translate_special_page(type, language)
    # Not found for given language, we create it from the page in default_language
    original_special_page = special_page(type, language: default_language)
    translated_special_page = original_special_page.translate!(language)
    # When we translate a new post, it will generate the permalink by looking for the posts special page
    # It will try to find it, or translate it if not found
    # At this moment, we need to sync the page with git (in case it's already published)
    translated_special_page.sync_with_git
    translated_special_page
  end
end
