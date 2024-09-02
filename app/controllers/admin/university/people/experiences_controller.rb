class Admin::University::People::ExperiencesController < Admin::University::ApplicationController
  load_and_authorize_resource :person,
                              class: University::Person,
                              through: :current_university,
                              through_association: :people,
                              parent: false
  def edit
    @l10n = @person.localization_for(current_language)
    breadcrumb
  end

  def update
    if @person.update(experiences_params)
      redirect_to admin_university_person_path(@person),
                  notice: t('admin.successfully_updated_html', model: @person.to_s)
    else
      render :edit
      breadcrumb
    end
  end

  private

  def breadcrumb
    super
    add_breadcrumb University::Person.model_name.human(count: 2), admin_university_people_path
    breadcrumb_for(@person)
    add_breadcrumb University::Person::Experience.model_name.human(count: 2)
  end

  def experiences_params
    params.require(:university_person)
          .permit(experiences_attributes: [
            :id, :organization_id, :from_year, :to_year, :_destroy,
            localizations_attributes: [
              :id, :description, :language_id
            ]
          ])
          .merge(university_id: current_university.id)
          .tap { |permitted_params|
            permitted_params[:experiences_attributes].transform_values! do |hash|
              hash.merge!(university_id: current_university.id)
            end
          }
  end

end
