module Admin::Reorderable
  extend ActiveSupport::Concern

  def reorder
    ids = params[:ids] || []
    first_object = model.find_by(id: ids.first)
    ids.each.with_index do |id, index|
      object = model.find_by(id: id)
      object.update_column(:position, index + 1) unless object.nil?
    end
    sync_after_reorder(first_object)
    # Used to add extra code
    yield first_object if block_given?
  end

  protected

  def sync_after_reorder(first_object)
    return unless first_object&.respond_to?(:is_direct_object?)
    first_object.is_direct_object?  ? first_object.sync_with_git
                                    : first_object.touch # Sync indirect object's direct sources through after_touch
  end

  def model
    self.class.to_s.remove('Admin::').remove('Controller').singularize.safe_constantize
  end
end
