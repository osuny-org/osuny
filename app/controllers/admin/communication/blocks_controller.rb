class Admin::Communication::BlocksController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Block,
                              through: :current_university,
                              through_association: :communication_blocks

  before_action :redirect_if_block_language_is_incorrect, only: [:edit, :update]

  def reorder
    # Cette action est très étrange, elle ne met pas en ordre les blocs seuls.
    # En fait, elle met en ordre dans le mode "Ecrire le contenu", à la fois les headings et les blocks.
    @ids = params[:ids] || []
    @index_block = 0
    @index_heading = 0
    @heading = nil
    @ids.values.each do |object|
      @object = object
      reorder_object
    end
    sync_after_reorder
  end

  def new
    @block.about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    breadcrumb
  end

  def show
    breadcrumb
  end

  def edit
    @element = @block.template.default_element
    breadcrumb
  end

  def create
    if @block.save
      redirect_to [:edit, :admin, @block],
                  notice: t('admin.successfully_created_html', model: @block.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @block.update(block_params)
      redirect_to about_path,
                  notice: t('admin.successfully_updated_html', model: @block.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:edit, :admin, @block.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @block.to_s)
  end

  def copy
    return unless request.xhr?
    cookies.signed[Communication::Block::BLOCK_COPY_COOKIE] = {
      value: params[:id],
      path: '/admin'
    }
  end

  def paste
    about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    # On réattribue à @block pour bénéficier du calcul dans about_path
    @block = @block.paste(about)
    cookies.delete(Communication::Block::BLOCK_COPY_COOKIE, path: '/admin')
    redirect_to about_path + "#block-#{@block.id}",
                notice: t('admin.successfully_duplicated_html', model: @block.to_s)
  end

  def destroy
    path = about_path
    @block.destroy
    redirect_to path,
                notice: t('admin.successfully_destroyed_html', model: @block.to_s)
  end

  protected

  def redirect_if_block_language_is_incorrect
    return if @block.language == current_language
    redirect_to about_path, alert: t('admin.communication.block.language_mismatch_alert')
  end

  def reorder_object
    @id = @object[:id]
    @object[:kind] == 'heading' ? reorder_heading
                                : reorder_block
  end

  def reorder_heading
    @heading = current_university.communication_block_headings.find(@id)
    @heading.update_columns position: @index_heading
    @index_block = 0
    @index_heading += 1
  end

  def reorder_block
    @block = current_university.communication_blocks.find(@id)
    @block.update_columns position: @index_block,
                          heading_id: @heading&.id
    @index_block += 1
  end

  def sync_after_reorder
    return unless @block && @block.about&.respond_to?(:is_direct_object?)
    @block.about.is_direct_object?  ? @block.about.sync_with_git
                                    : @block.about.touch # Sync indirect object's direct sources through after_touch
  end

  def website_id
    params[:website_id] || @block.about&.website.id
  rescue
  end

  def extranet_id
    params[:extranet_id] || @block.about&.extranet.id
  rescue
  end

  def journal_id
    params[:journal_id] || @block.about&.journal.id
  rescue
  end

  def about_path
    # Les headings sont toujours affectés à des localisations
    l10n = @block.about
    # La localisation porte sur un objet, par exemple une University::Person ou un Communication::Website::Post
    object_edited = l10n.about
    # La formation ou la page concernée
    path_method = "admin_#{object_edited.class.base_class.to_s.parameterize.underscore}_path"
    path_method_options = {
      id: object_edited.id,
      lang: l10n.language,
      website_id: website_id,
      extranet_id: extranet_id,
      journal_id: journal_id
    }
    public_send path_method, **path_method_options
  end

  def breadcrumb
    short_breadcrumb
    add_breadcrumb @block.about, about_path
    if @block.new_record?
      add_breadcrumb t('admin.communication.blocks.choose.title')
    else
      add_breadcrumb @block
    end
  end

  def block_params
    params.require(:communication_block)
          .permit(:about_id, :about_type, :template_kind, :title, :data, :published)
          .merge(university_id: current_university.id)
  end
end
