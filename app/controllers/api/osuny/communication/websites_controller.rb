class Api::Osuny::Communication::WebsitesController < Api::Osuny::Communication::Websites::ApplicationController
  def index
    @websites = websites.includes(:localizations)
  end

  def show
    @website = websites.find params[:id]
  end
end
