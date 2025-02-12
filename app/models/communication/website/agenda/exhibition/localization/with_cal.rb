module Communication::Website::Agenda::Exhibition::Localization::WithCal
  extend ActiveSupport::Concern

  included do
    before_save :set_add_to_calendar_urls
  end

  def cal
    @cal ||= AddToCalendar::URLs.new(
      start_datetime: cal_from_time,
      end_datetime: cal_to_time,
      timezone: time_zone,
      all_day: true,
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

  def cal_from_time
    from_day.to_time
  end

  def cal_to_time
    # Si all_day == true et qu'on ne transmet pas de date de fin, l'événement sera considéré comme un événement d'une journée
    # On peut donc early return selon ces conditions
    return if from_day == to_day
    to_day.to_time
  end

  def set_add_to_calendar_urls
    self.add_to_calendar_urls = {
      'google' => cal.google_url,
      'yahoo' => cal.yahoo_url,
      'office' => cal.office365_url,
      'outlook' => cal.outlook_com_url,
      'ical' => cal.ical_url
    }
  end

end
