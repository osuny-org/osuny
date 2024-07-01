class Admin::University::Organizations::CategoriesController < Admin::University::ApplicationController
  load_and_authorize_resource class: 'University::Organization::Category',
                              through: :current_university,
                              through_association: :organization_categories

  include Admin::Categorizable
  include Admin::Localizable

  def index
    @root_categories = categories.root
                                 .in_closest_language_id(current_language.id)
                                 .ordered
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/university/organizations'
    breadcrumb
  end

  def show
    @organizations = @category.organizations.ordered.page(params[:page])
    breadcrumb
  end

  def static
    @about = @category
    @website = @category.websites&.first
    render_as_plain_text
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @category.language_id = current_language.id
    if @category.save
      redirect_to admin_university_organization_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_university_organization_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_university_organization_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s)
  end

  protected

  def categories_class
    University::Organization::Category
  end

  def categories
    current_university.organization_categories.ordered
  end

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2),
                    admin_university_organizations_path
    add_breadcrumb  University::Organization::Category.model_name.human(count: 2),
                    admin_university_organization_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:university_organization_category)
          .permit(:name)
          .merge(university_id: current_university.id)
  end
end
