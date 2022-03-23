class Extranet::OrganizationsController < Extranet::ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  def index
    @organizations = @organizations.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Organization.model_name.human(count: 2), university_organizations_path
    add_breadcrumb @organization if @organization
  end
end
