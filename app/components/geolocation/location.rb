module Geolocation
  class Location < ApplicationRecord
    self.table_name = 'locations'

    validates :ip_address, :country_code, :country, :city, :latitude, :longitude, presence: true
  end
end
