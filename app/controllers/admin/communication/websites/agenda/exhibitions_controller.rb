class Admin::Communication::Websites::Agenda::ExhibitionsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Exhibition,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @exhibitions = @exhibitions.filter_by(params[:filters], current_language)
                     .ordered_desc
                     .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/agenda'
    breadcrumb
  end

  def publish
    @l10n.publish!
    @exhibition.sync_with_git
    redirect_back fallback_location: admin_communication_website_agenda_exhibition_path(@exhibition),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @exhibition.website = @website
    @exhibition.created_by = current_user
    if @exhibition.save_and_sync
      redirect_to admin_communication_website_agenda_exhibition_path(@exhibition),
                  notice: t('admin.successfully_created_html', model: @exhibition.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @exhibition.update_and_sync(exhibition_params)
      redirect_to admin_communication_website_agenda_exhibition_path(@exhibition),
                  notice: t('admin.successfully_updated_html', model: @exhibition.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @exhibition.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @exhibition.to_s_in(current_language))
  end

  def destroy
    @exhibition.destroy
    redirect_to admin_communication_website_agenda_exhibitions_url,
                notice: t('admin.successfully_destroyed_html', model: @exhibition.to_s_in(current_language))
  end
  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Agenda::Exhibition.model_name.human(count: 2),
                    admin_communication_website_agenda_exhibitions_path
    breadcrumb_for @exhibition
  end

  def categories
    @website.agenda_categories.ordered
  end

  def exhibition_params
    params.require(:communication_website_agenda_exhibition)
    .permit(
      :from_day, :from_hour, :to_day, :to_hour, :time_zone,
      category_ids: [],
      localizations_attributes: [
        :id, :title, :subtitle, :meta_description, :summary, :text,
        :published, :published_at, :slug,
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
end