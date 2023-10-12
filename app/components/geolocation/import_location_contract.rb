module Geolocation
  class ImportLocationContract < Dry::Validation::Contract
    schema do
      required(:ip_address).filled(Types::String)
      required(:country_code).filled(Types::String, max_size?: 2)
      required(:country).filled(Types::String, max_size?: 100)
      required(:city).filled(Types::String, max_size?: 100)
      required(:latitude).filled(Types::Coercible::Float)
      required(:longitude).filled(Types::Coercible::Float)
      required(:created_at).filled(Types::Time)
      required(:updated_at).filled(Types::Time)
    end

    rule(:ip_address) do
      IPAddr.new(value)
    rescue IPAddr::InvalidAddressError
      key.failure("Invalid IP address")
    end
  end
end
