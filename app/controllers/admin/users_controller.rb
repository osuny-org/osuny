class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @users = current_university.users
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb 'Modifier'
  end

  def create
    if @user.save
      redirect_to [:admin, @user], notice: "User was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user.modified_by = current_user
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: "User was successfully updated."
    else
      breadcrumb
      add_breadcrumb 'Modifier'
      render :edit, status: :unprocessable_entity
    end
  end

  def unlock
    if @user.access_locked? || @user.max_login_attempts?
      @user.unlock_access!
      @user.unlock_mfa!
      redirect_back(fallback_location: [:admin, @user], notice: 'User account was successfully unlocked.')
    else
      redirect_back(fallback_location: [:admin, @user], alert: 'User account was not locked.')
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: "User was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb User.model_name.human(count: 2), admin_users_path
    if @user
      if @user.persisted?
        add_breadcrumb @user, [:admin, @user]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :language_id, :picture, :picture_delete, :mobile_phone)
  end
end
