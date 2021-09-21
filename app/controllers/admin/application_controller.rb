class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :authenticate_user!

  protected

  def breadcrumb
    add_breadcrumb t('dashboard'), :admin_root_path
  end

  def short_breadcrumb
    @menu_collapsed = true
    add_breadcrumb t('dashboard'), :admin_root_path
    add_breadcrumb '...'
  end

  def breadcrumb_for(object, **options)
    return unless object
    object.persisted? ? add_breadcrumb(object, [:admin, object, options])
                      : add_breadcrumb('Créer')
  end
end
