class Admin::Education::ProgramsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  before_action :load_teacher_people, only: [:new, :edit, :create, :update]

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @programs = @programs.filter_by(params[:filters], current_language)
                         .tmp_original # TODO L10N : To remove.
                         .ordered_by_name(current_language)
                         .page(params[:page])
    breadcrumb
  end

  def tree
    @programs = @programs.root
                         .tmp_original # TODO L10N : To remove.
                         .ordered
    breadcrumb
    add_breadcrumb t('.title')
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    old_parent_id = params[:oldParentId].blank? ? nil : params[:oldParentId]
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      program = current_university.education_programs.find(id)
      program.update_columns  parent_id: parent_id,
                              position: index + 1
    end
    if old_parent_id
      old_parent = current_university.education_programs.find(old_parent_id)
      old_parent.set_websites_categories
      old_parent.touch
    end
    program = current_university.education_programs.find(params[:itemId])
    program.set_websites_categories
    program.touch
  end

  def children
    return unless request.xhr?
    @children = @program.children.tmp_original.ordered  # TODO L10N : To remove.
  end

  def show
    @roles = @program.university_roles.ordered
    @teacher_involvements = @program.university_person_involvements.includes(:person).ordered_by_name(current_language)
    @preview = true
    breadcrumb
  end

  def preview
    @website = @program.websites&.first
    render layout: 'admin/layouts/preview'
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @l10n.add_photo_import params[:photo_import]
    if @program.save
      redirect_to [:admin, @program], notice: t('admin.successfully_created_html', model: @program.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @l10n.add_photo_import params[:photo_import]
    if @program.update(program_params)
      redirect_to [:admin, @program], notice: t('admin.successfully_updated_html', model: @program.to_s_in(current_language))
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy
    redirect_to admin_education_programs_url, notice: t('admin.successfully_destroyed_html', model: @program.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Program.model_name.human(count: 2), admin_education_programs_path
    breadcrumb_for @program
  end

  def program_params
    params.require(:education_program)
          .permit(
            :bodyclass, :capacity, :continuing, :initial, :apprenticeship, :qualiopi_certified,
            :parent_id, :diploma_id, school_ids: [],
            university_person_involvements_attributes: [
              :id, :person_id, :university_id, :position, :_destroy,
              localizations_attributes: [:id, :description, :language_id]
            ],
            localizations_attributes: [
              :id, :language_id,
              :name, :short_name, :slug, :url,
              :meta_description, :summary, :published,
              :qualiopi_text,
              :logo, :logo_delete,
              :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
              :shared_image, :shared_image_delete,
              :prerequisites, :objectives, :presentation, :registration, :pedagogy, :content, :registration_url,
              :evaluation, :accessibility, :contacts, :opportunities, :results, :other, :main_information,
              :pricing, :pricing_apprenticeship, :pricing_continuing, :pricing_initial, :duration,
              :downloadable_summary, :downloadable_summary_delete,
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end

  def load_teacher_people
    @teacher_people = current_university.people
                                        .tmp_original # TODO L10N : To remove.
                                        .teachers
                                        .accessible_by(current_ability)
                                        .ordered(current_language)
  end
end
