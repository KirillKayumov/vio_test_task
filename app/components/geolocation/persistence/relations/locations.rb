module Geolocation
  module Persistence
    module Relations
      class Locations < ROM::Relation[:sql]
        schema(:locations) do
          attribute :id, Types::Integer
          attribute :ip_address, Types::String
          attribute :country_code, Types::String
          attribute :country, Types::String
          attribute :city, Types::String
          attribute :latitude, Types::Float
          attribute :longitude, Types::Float
          attribute :created_at, Types::Time
          attribute :updated_at, Types::Time
        end
      end
    end
  end
end
