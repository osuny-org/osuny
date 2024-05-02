class Admin::Research::JournalsController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Journal,
                              through: :current_university,
                              through_association: :research_journals

  has_scope :for_search_term

  def index
    @journals = apply_scopes(@journals).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @papers = @journal.papers.ordered.limit(10)
    @kinds = @journal.kinds.ordered
    @volumes = @journal.volumes.ordered
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
    if @journal.save
      redirect_to [:admin, @journal], notice: t('admin.successfully_created_html', model: @journal.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @journal.update(journal_params)
      redirect_to [:admin, @journal], notice: t('admin.successfully_updated_html', model: @journal.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @journal.destroy
    redirect_to admin_research_journals_url, notice: t('admin.successfully_destroyed_html', model: @journal.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Journal.model_name.human(count: 2), admin_research_journals_path
    breadcrumb_for @journal
  end

  def journal_params
    params.require(:research_journal)
          .permit(:title, :meta_description, :summary, :issn, :language_id)
          .merge(university_id: current_university.id)
  end
end
