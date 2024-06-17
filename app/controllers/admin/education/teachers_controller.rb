class Admin::Education::TeachersController < Admin::Education::ApplicationController
  load_and_authorize_resource class: University::Person::Teacher,
                              through: :current_university,
                              through_association: :people

  has_scope :for_search_term
  has_scope :for_program

  def index
    @teachers = apply_scopes(
      current_university.people
                        .in_closest_language_id(current_language.id)
                        .teachers
                        .accessible_by(current_ability)
    ).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @involvements = @teacher.involvements_as_teacher
                            .includes(:target)
                            .ordered_by_date
                            .page(params[:page])
    breadcrumb
  end

  def edit
    authorize!(:update, @teacher)
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    authorize!(:update, @teacher)
    if @teacher.update(teacher_params)
      redirect_to admin_education_teacher_path(@teacher), notice: t('admin.successfully_updated_html', model: @teacher.to_s)
    else
      render :edit
      breadcrumb
      add_breadcrumb t('edit')
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Teacher.model_name.human(count: 2), admin_education_teachers_path
    add_breadcrumb @teacher, admin_education_teacher_path(@teacher) if @teacher
  end

  def teacher_params
    params.require(:university_person).permit(
      involvements_attributes: [:id, :target_id, :target_type, :description, :_destroy]
    )
  end
end
