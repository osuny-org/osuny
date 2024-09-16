class Server::UniversitiesController < Server::ApplicationController

  load_and_authorize_resource

  has_scope :for_search_term
  has_scope :for_real_university
  has_scope :for_contribution
  has_scope :for_university_kind
  has_scope :for_language

  def index
    @universities = apply_scopes(@universities).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @websites = @university.websites.ordered(current_language).page(params[:page])
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @university.source_university_id = current_university.id
    if @university.save
      redirect_to [:server, @university], notice: t('admin.successfully_created_html', model: @university.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @university.update(university_params)
      redirect_to [:server, @university], notice: t('admin.successfully_updated_html', model: @university.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @university.destroy
    redirect_to server_universities_url, notice: t('admin.successfully_destroyed_html', model: @university.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human(count: 2), server_universities_path
    if @university
      if @university.persisted?
        add_breadcrumb @university, [:server, @university]
      else
        add_breadcrumb t('create')
      end
    end
  end

  def university_params
    params.require(:university).permit(:name,
      :address, :zipcode, :city, :country,
      :private, :identifier, :logo, :logo_delete, :sms_sender_name,
      :has_sso, :sso_target_url, :sso_cert, :sso_name_identifier_format, :sso_mapping, :sso_button_label,
      :invoice_date, :contribution_amount,
      :is_really_a_university,
      :default_language_id, language_ids: []
    )
  end

end
