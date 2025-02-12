module Communication::Website::Agenda::Event::Localization::WithCal
  extend ActiveSupport::Concern

  included do
    before_save :set_add_to_calendar_urls
  end

  def cal
    @cal ||= AddToCalendar::URLs.new(
      start_datetime: cal_from_time,
      end_datetime: cal_to_time,
      timezone: time_zone,
      all_day: cal_all_day,
      title: "#{title} #{subtitle}",
      url: current_permalink_url_in_website(website),
      description: summary
    )
  end

  def cal_google_url
    add_to_calendar_urls['google']
  end

  def cal_yahoo_url
    add_to_calendar_urls['yahoo']
  end

  def cal_office_url
    add_to_calendar_urls['office']
  end

  def cal_outlook_url
    add_to_calendar_urls['outlook']
  end

  def cal_ical_url
    add_to_calendar_urls['ical']
  end

  protected

  def set_add_to_calendar_urls
    self.add_to_calendar_urls = {
      'google' => cal.google_url,
      'yahoo' => cal.yahoo_url,
      'office' => cal.office365_url,
      'outlook' => cal.outlook_com_url,
      'ical' => cal.ical_url
    }
  end

  def cal_from_time
    from_hour.nil?  ? from_day.to_time
                    : date_and_time(from_day, from_hour)
  end

  def cal_to_time
    # Si all_day == true et qu'on ne transmet pas de date de fin, l'événement sera considéré comme un événement d'une journée
    # On peut donc early return selon ces conditions
    return if cal_all_day && from_day == to_day
    to_day.nil? ? cal_to_time_with_no_end_day
                : cal_to_time_with_end_day
  end

  def cal_all_day
    from_hour.nil? && to_hour.nil?
  end

  # Ce cas n'est plus possible depuis la résolution #1386
  def cal_to_time_with_no_end_day
    to_hour.nil?  ? nil # Pas de fin
                  : date_and_time(from_day, to_hour) # Heure de fin sans jour de fin, donc on se base sur le jour de début
  end

  def cal_to_time_with_end_day
    # Soit on a 1 heure de fin, et tout est simple
    cal_end_time = to_hour
    # Soit on n'en a pas, mais on a 1 heure de début, donc on ajoute 1 heure pour éviter les événements sans durée
    cal_end_time ||= from_hour + 1.hour if from_hour
    # Si rien n'a marché, on a nil
    cal_end_time.nil? ? to_day.to_time # Il n'y a ni heure de fin ni heure de début
                      : date_and_time(to_day, cal_end_time) # Il y a bien une heure de fin
  end

  def date_and_time(date, time)
    Time.new  date.year,
              date.month,
              date.day,
              time.hour,
              time.min,
              time.sec,
              ActiveSupport::TimeZone[time_zone]
  end

end
