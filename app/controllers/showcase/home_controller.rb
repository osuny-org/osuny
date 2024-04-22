class Showcase::HomeController < Showcase::ApplicationController
  def index
    @websites = Communication::Website.in_showcase
                                      .order(created_at: :desc)
  end
end
