class LocationsController < ApplicationController
  before_action :validate_params, only: :show

  def show
    location = Geolocation::Location.find_by(ip_address: params[:ip_address])

    if location
      render json: location.slice(:country_code, :country, :city, :latitude, :longitude)
    else
      render json: { error_code: :location_not_found }, status: 404
    end
  end

  private

  def validate_params
    render json: { error_code: :missing_ip_address }, status: 400 unless params[:ip_address].present?
  end
end
