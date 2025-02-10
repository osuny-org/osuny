class Admin::Communication::Websites::PagesController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Page,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  before_action :load_localization,
                :redirect_if_not_localized,
                only: [:show, :edit, :update, :static, :publish, :preview, :generate_from_template]

  def index
    @homepage = @website.special_page(Communication::Website::Page::Home)
    @first_level_pages = @homepage.children.ordered
    @pages = @website.pages
    @feature_nav = 'navigation/admin/communication/website/pages'
    breadcrumb
  end

  def index_list
    @pages = @pages.filter_by(params[:filters], current_language)
                   .ordered_by_title(current_language)
                   .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/pages'
    breadcrumb
  end

  def reorder
    parent_page = @website.pages.find(params[:parentId])
    old_parent_page = @website.pages.find(params[:oldParentId])
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      page = @website.pages.find(id)
      page.update_columns parent_id: parent_page.id,
                          position: index + 1
    end
    old_parent_page.sync_with_git
    parent_page.sync_with_git if parent_page != old_parent_page
    @website.generate_automatic_menus_for_language(current_language)
  end

  def children
    if request.xhr?
      @children = @page.children.ordered
    else
      redirect_to admin_communication_website_pages_path
    end
  end

  def show
    @preview = true
    breadcrumb
    add_breadcrumb(@l10n, admin_communication_website_page_path(@page))
  end

  def publish
    @l10n.publish!
    @page.sync_with_git
    redirect_back fallback_location: admin_communication_website_page_path(@page),
                  notice: t('admin.communication.website.publish.notice')
  end

  def preview
    render layout: 'admin/layouts/preview'
  end

  def connect
    load_object
    @website.connect_and_sync @object, @page, direct_source_type: @page.class.to_s
    head :ok
  end

  def disconnect
    load_object
    @website.disconnect_and_sync @object, @page, direct_source_type: @page.class.to_s
    redirect_back(fallback_location: [:admin, @object])
  end

  def generate_from_template
    @page.generate_from_template(@l10n)
    redirect_back(fallback_location: [:admin, @page])
  end

  def new
    @page.website = @website
    @categories = categories
    breadcrumb
    add_breadcrumb(t('create'))
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb(@l10n, admin_communication_website_page_path(@page))
    add_breadcrumb t('edit')
  end

  def create
    @page.website = @website
    if @page.save_and_sync
      redirect_to admin_communication_website_page_path(@page),
                  notice: t('admin.successfully_created_html', model: @page.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      add_breadcrumb(t('create'))
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @page.update_and_sync(page_params)
      redirect_to admin_communication_website_page_path(@page),
                  notice: t('admin.successfully_updated_html', model: @page.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb(@page, admin_communication_website_page_path(@page))
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    if @page.is_special_page?
      redirect_back(fallback_location: admin_communication_website_page_path(@page), alert: t('admin.communication.website.pages.duplicate_special_page_notice'))
    else
      redirect_to [:admin, @page.duplicate],
                  notice: t('admin.successfully_duplicated_html', model: @page.to_s)
    end
  end

  def destroy
    if @page.is_special_page?
      redirect_back(fallback_location: admin_communication_website_page_path(@page), alert: t('admin.communication.website.pages.delete_special_page_notice'))
    else
      @page.destroy
      redirect_to admin_communication_website_pages_url(@website), notice: t('admin.successfully_destroyed_html', model: @page.to_s_in(current_language))
    end
  end

  protected

  def load_object
    @object = PolymorphicObjectFinder.find(
      params,
      key: :object,
      university: current_university,
      permitted_classes: [@page.class.direct_connection_permitted_about_class]
    )
  end

  def breadcrumb
    super
    add_breadcrumb  t('admin.communication.website.subnav.structure'),
                    admin_communication_website_pages_path
  end

  def page_params
    params.require(:communication_website_page)
          .permit(
            :communication_website_id, :bodyclass, :full_width, :parent_id, :design_options, category_ids: [],
            localizations_attributes: [
              :id, :title, :breadcrumb_title, :meta_description, :summary, :header_text, :text, :slug, :published,
              :header_cta, :header_cta_label, :header_cta_url, 
              :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
              :shared_image, :shared_image_delete, :shared_image_infos,
              :language_id
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end

  def categories
    @website.page_categories
            .ordered
  end

end
