class Server::ApplicationController < ApplicationController
  layout 'server/layouts/application'

  before_action :authenticate_user!, :ensure_user_if_server_admin

  protected

  def breadcrumb
    add_breadcrumb t('server_admin.dashboard'), :server_root_path
  end

  def ensure_user_if_server_admin
    raise CanCan::AccessDenied unless current_user.server_admin?
  end

  def current_language
    @current_language ||= current_university.default_language
  end
end
