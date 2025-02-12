module Communication::Website::Agenda::Event::WithDays
  extend ActiveSupport::Concern

  included do
    has_many  :days,
              foreign_key: :communication_website_agenda_event_id
    after_save :generate_days
  end

  protected

  def generate_days
    # Days are used to group children
    return unless kind_parent?
    days.destroy_all
    date = from_day
    loop do 
      generate_day(date)
      date += 1.day
      break if date > to_day
    end
  end

  def generate_day(date)
    website.languages.each do |language|
      day = days.where(
        university: university,
        website: website,
        language: language,
        date: date,
      ).create
    end
  end
end