module Communication::Website::Agenda::Event::WithKinds
  extend ActiveSupport::Concern

  included do
    after_save :sync_parent_if_child
  end

  def kind_simple?
    children.none? && !multiple_time_slots?
  end

  def kind_recurring?
    children.none? && multiple_time_slots?
  end

  def kind_parent?
    children.any?
  end

  def kind_child?
    parent.present?
  end

  def can_have_children?
    parent.nil?
  end

  def can_have_time_slots?
    children.none?
  end

  def multiple_time_slots?
    time_slots.count > 1
  end

  protected

  def sync_parent_if_child
    return unless kind_child?
    # @SebouChu je suis pas du tout sûr. Ca fonctionne (mise à jour du parent ok)
    parent.sync_with_git
  end
end
