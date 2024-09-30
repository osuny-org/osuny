module Communication::Website::Page::WithAutomaticMenus
  extend ActiveSupport::Concern

  included do
    after_save :generate_automatic_menus
  end

  protected

  def generate_automatic_menus
    website.generate_automatic_menus_for_identifier(default_menu_identifier)
  end
end