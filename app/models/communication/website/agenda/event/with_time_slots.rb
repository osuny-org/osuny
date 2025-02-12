module Communication::Website::Agenda::Event::WithTimeSlots
  extend ActiveSupport::Concern

  included do
    has_many  :time_slots,
              foreign_key: :communication_website_agenda_event_id
  end

  def save_time_slots(language, params)
    params[:slots].each do |slot|
      next if slot[:date].blank?  || slot[:time].blank?
      date = slot[:date].to_date
      time = slot[:time].to_time
      datetime = Time.new date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.min,
                          time.sec,
                          ActiveSupport::TimeZone[time_zone]
      if slot[:id].present?
        time_slot = time_slots.find(slot[:id])
        time_slot.datetime = datetime
      else
        time_slot = time_slots.where(
          university: university,
          website: website,
          datetime: datetime
        ).first_or_create
      end
      time_slot.duration = slot[:duration].to_i
      time_slot.save
    end
  end

  def time_slots_to_json(language)
    {
      min: from_day.strftime('%F'),
      max: to_day.strftime('%F'),
      slots: time_slots.ordered.map { |slot| 
        {
          id: slot.id,
          date: slot.date,
          time: slot.time,
          place: '',
          duration: slot.duration
        }
      }
    }
  end
end