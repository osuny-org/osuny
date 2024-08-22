class Users::RegistrationsController < Devise::RegistrationsController
  include Users::AddContextToRequestParams
  include Users::LayoutChoice

  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :confirm_two_factor_authenticated, except: [:new, :create, :cancel]

  def edit
    add_breadcrumb t('admin.dashboard'), admin_root_path(lang: current_university.default_language)
    if can? :read, @user
      add_breadcrumb User.model_name.human(count: 2), admin_users_path
      add_breadcrumb @user, [:admin, @user]
      add_breadcrumb t('edit')
    else
      add_breadcrumb t('menu.profile')
    end
  end

  def update
    super do |resource|
      # Re-set I18n.locale in case of language change.
      I18n.locale = resource.language.iso_code.to_sym
    end
  end

  protected

  def sign_up(resource_name, resource)
    sign_in(resource, event: :authentication)
  end

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_infos, :picture_delete])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:mobile_phone, :language_id, :first_name, :last_name, :picture, :picture_infos, :picture_delete, :admin_theme])
  end

  def sign_up_params
    devise_parameter_sanitized = devise_parameter_sanitizer.sanitize(:sign_up).merge(registration_context: current_context)
  end

  def confirm_two_factor_authenticated
    return if is_fully_authenticated?
    flash[:alert] = t('devise.failure.unauthenticated')
    redirect_to user_two_factor_authentication_url
  end
end
