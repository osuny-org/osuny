module InTime
  extend ActiveSupport::Concern
  
  STATUS_FUTURE = 'future'
  STATUS_CURRENT = 'current'
  STATUS_ARCHIVE = 'archive'

  included do
    scope :future, -> { 
      where('from_day > :today', today: Date.today)
      .ordered_asc 
    }
    scope :current, -> { 
      where('(from_day <= :today AND to_day IS NULL) OR (from_day <= :today AND to_day >= :today)', today: Date.today)
      .ordered_asc
    }
    scope :future_or_current, -> { 
      future.or(current)
      .ordered_asc 
    }
    scope :archive, -> { 
      where('to_day < :today', today: Date.today)
      .ordered_desc 
    }
    scope :past, -> { archive }

    before_validation :set_time_zone
    before_validation :set_to_day

    validates :from_day, presence: true
    validate :to_day_after_from_day, :to_hour_after_from_hour_on_same_day
  end

  def status
    if future?
      STATUS_FUTURE
    elsif current?
      STATUS_CURRENT
    else
      STATUS_ARCHIVE
    end
  end

  def future?
    from_day > Date.today
  end

  def current?
    to_day.present? ? (Date.today >= from_day && Date.today <= to_day)
                    : from_day <= Date.today # Les événements sans date de fin restent actifs
  end

  def archive?
    to_day.present? ? to_day < Date.today
                    : false # Les événements sans date de fin restent actifs
  end

  def same_day?
    from_day == to_day
  end

  def has_hours?
    from_hour.present? || to_hour.present?
  end

  def has_specific_time_zone?
    time_zone != website.default_time_zone
  end

  def from_datetime
    time_with from_day, from_hour
  end

  def to_datetime
    time_with to_day, to_hour
  end

  # Un événement demain aura une distance de 1, comme un événement hier
  # On utilise cette info pour classer les événements à venir dans un sens et les archives dans l'autre
  def distance_in_days
    (Date.today - from_day).to_i.abs
  end

  protected

  def set_time_zone
    self.time_zone = website.default_time_zone if self.time_zone.blank?
  end

  def set_to_day
    self.to_day = self.from_day if self.to_day.nil?
  end

  def to_day_after_from_day
    errors.add(:to_day, :too_soon) if to_day.present? && to_day < from_day
  end

  def to_hour_after_from_hour_on_same_day
    return if from_day != to_day
    return unless respond_to?(:from_hour) && respond_to?(:to_hour)
    errors.add(:to_hour, :too_soon) if to_hour.present? && from_hour.present? && to_hour <= from_hour
  end
end
