class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :redirect_if_context_is_not_an_university!
  before_action :load_block_copy_cookie

  include Admin::Filterable

  def set_theme
    current_user.update_column :admin_theme, params[:theme]
    redirect_to admin_root_path
  end

  protected

  def breadcrumb
    add_breadcrumb t('admin.dashboard'), admin_root_path(website_id: nil)
  end

  def short_breadcrumb
    @menu_collapsed = true
    add_breadcrumb t('admin.dashboard'), admin_root_path(website_id: nil)
    add_breadcrumb '...'
  end

  def breadcrumb_for(object, **options)
    return unless object
    title = object.to_s.truncate(50)
    object.persisted? ? add_breadcrumb(title, [:admin, object, options])
                      : add_breadcrumb(t('create'))
  end

  def load_block_copy_cookie
    block_id = cookies.signed[Communication::Block::BLOCK_COPY_COOKIE]
    return if block_id.nil?
    @block_copied = current_university.communication_blocks.find block_id
  rescue
    # If the block doesn't exist anymore
  end

  private

  def redirect_if_context_is_not_an_university!
    # Currently (Nov 2023), context can be: an extranet, an university (admin) or none.
    redirect_to root_path unless current_context.is_a?(University)
  end

end
