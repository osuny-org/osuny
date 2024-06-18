module University::Person::WithPicture
  extend ActiveSupport::Concern

  included do
    has_one_attached_deletable :picture

    validates :picture, size: { less_than: 5.megabytes }

    alias :featured_image :best_picture
  end

  def best_picture
    @best_picture ||= begin
      best_picture = picture
      best_picture = user.picture if !picture.attached? && user.present?
      best_picture
    end
  end

  def best_picture_inherits_from_user?
    user.present? && best_picture == user.picture
  end
end
