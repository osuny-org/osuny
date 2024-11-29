class Api::Osuny::Communication::Websites::PostsController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :load_migration_identifier,
                :load_post,
                only: [:create, :update]

  def index
    @posts = website.posts.includes(:localizations)
  end

  def show
    @post = website.posts.find params[:id]
  end

  def create
    @post.assign_attributes post_params
    if @post.save
      render json: @post
    else
      render json: @post.errors
    end
  end

  def update
    if @post.update post_params
      render json: @post
    else
      render json: @post.errors
    end
  end

  # def import
  #   Importers::Api::Osuny::Communication::Website::Post.new university: current_university,
  #                                                           website: website,
  #                                                           params: params[:post]
  #   render json: :ok
  # end

  protected

  def load_migration_identifier
    @migration_identifier = post_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def load_post
    @post = website.posts.where(
        migration_identifier: @migration_identifier,
        language: @language
      ).first_or_initialize
  end

  def post_params
    params.require(:post)
          .permit(
            :migration_identifier, :full_width,
            localizations_attributes: [
              :migration_identifier, :language, :title
            ]
          ).merge(
            university_id: current_university.id,
            communication_website_id: website.id
          )
  end
end
