class Extranet::ExperiencesController < Extranet::ApplicationController
  before_action :load_experience, only: [:edit, :update, :destroy]
  def new
    @experience = current_user.experiences.new
    @l10n = @experience.localizations.build(language: current_language)
    breadcrumb
    add_breadcrumb University::Person::Experience.human_attribute_name('new')
  end

  def edit
    @l10n = @experience.localization_for(current_language)
    breadcrumb
  end

  def create
    @experience = current_user.experiences.new(experience_params)
    if @experience.save
      redirect_to account_path,
                  notice: t('admin.successfully_created_html', model: @experience.organization.to_s)
    else
      @l10n = @experience.localizations.build(language: current_language)
      breadcrumb
      add_breadcrumb University::Person::Experience.human_attribute_name('new')
      render :new
    end
  end

  def update
    if @experience.update experience_params
      redirect_to account_path,
                  notice: t('admin.successfully_updated_html', model: @experience.organization.to_s)
    else
      breadcrumb
      render :edit
    end
  end

  def destroy
    @experience.destroy
    redirect_to account_path,
                notice: t('admin.successfully_destroyed_html', model: @experience.organization.to_s)
  end

  protected

  def load_experience
    @experience = current_user.experiences.find_by!(id: params[:id])
  end

  def experience_params
    params.require(:university_person_experience)
          .permit(
            :from_year, :to_year, :organization_id, :organization_name,
            localizations_attributes: [
              :id, :language_id,
              :description
            ]  
          )
          .merge(
            university_id: current_university.id
          )
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
  end
end
