class Admin::Research::Journal::ArticlesController < Admin::Research::Journal::ApplicationController
  load_and_authorize_resource class: Research::Journal::Article

  def index
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
    add_breadcrumb t('edit')
  end

  def create
    @journal = current_university.research_journals.find params[:journal_id]
    @article.journal = @journal
    @article.university = @journal.university
    @article.updated_by = current_user
    if @article.save
      redirect_to admin_research_journal_article_path(@article), notice: t('admin.successfully_created_html', model: @article.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @article.updated_by = current_user
    if @article.update(article_params)
      redirect_to admin_research_journal_article_path(@article), notice: t('admin.successfully_updated_html', model: @article.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
  end
  end

  def destroy
    @journal = @article.journal
    @article.destroy
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @article.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Article.model_name.human(count: 2), admin_research_journal_articles_path
    breadcrumb_for @article
  end

  def article_params
    params.require(:research_journal_article)
          .permit(:title, :text, :published_at, :abstract, :pdf, :references, :keywords, :research_journal_volume_id, researcher_ids: [])
          .merge(university_id: current_university.id)
  end
end
