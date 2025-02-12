class Admin::Communication::Websites::Agenda::EventsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Event,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @events = @events.filter_by(params[:filters], current_language)
                     .ordered_desc
                     .root
                     .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/agenda'
    breadcrumb
  end

  def publish
    @l10n.publish!
    @event.sync_with_git
    redirect_back fallback_location: admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    breadcrumb
  end

  def new
    @event.parent = @website.events.find(params[:parent_id]) if params.has_key?(:parent_id)
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @event.website = @website
    @event.created_by = current_user
    if @event.save_and_sync
      redirect_to admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.successfully_created_html', model: @event.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update_and_sync(event_params)
      redirect_to admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.successfully_updated_html', model: @event.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def save_time_slots
    @event.save_time_slots(current_language, params.to_unsafe_hash)
    render json: @event.time_slots_to_json(current_language)
  end

  def duplicate
    redirect_to [:admin, @event.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @event.to_s_in(current_language))
  end

  def destroy
    @event.destroy
    redirect_to admin_communication_website_agenda_events_url,
                notice: t('admin.successfully_destroyed_html', model: @event.to_s_in(current_language))
  end
  protected

  def breadcrumb
    super
    add_breadcrumb @event.parent.to_s_in(current_language), [:admin, @event.parent] if @event&.parent
    breadcrumb_for @event
  end

  def categories
    @website.agenda_categories.ordered
  end

  def event_params
    params.require(:communication_website_agenda_event)
    .permit(
      :from_day, :from_hour, :to_day, :to_hour, :time_zone,
      :parent_id, category_ids: [],
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