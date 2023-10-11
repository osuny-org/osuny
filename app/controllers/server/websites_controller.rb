class Server::WebsitesController < Server::ApplicationController
  before_action :load_website, except: :index

  has_scope :for_theme_version
  has_scope :for_production
  has_scope :for_update
  has_scope :for_search_term
  has_scope :for_updatable_theme

  def index
    @websites = apply_scopes(Communication::Website.all).ordered
    breadcrumb
  end

  def sync_theme_version
    @website.get_current_theme_version!
  end

  def update_theme
    @website.update_theme_version
  end

  def show
    breadcrumb
    add_breadcrumb @website
  end

  def update
    @website.update(website_params)
    @website.recursive_dependencies.each do |dependency|
      next unless dependency.respond_to?(:university_id)
      dependency.update_column :university_id, @website.university_id
    end
    redirect_to server_website_path(@website), notice: t('admin.successfully_updated_html', model: @website.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), server_websites_path
  end

  def load_website
    @website = Communication::Website.find params[:id]
  end

  def website_params
    params.require(:communication_website).permit(:university_id)
  end
end
