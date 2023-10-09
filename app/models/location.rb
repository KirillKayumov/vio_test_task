class Location < ApplicationRecord
  validates :ip_address, :country_code, :country, :city, :latitude, :longitude, presence: true

end
