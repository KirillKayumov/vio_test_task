module Geolocation
  module Persistence
    module Repos
      class LocationsRepo < ROM::Repository[:locations]
        def import(attributes)
          locations.dataset.insert_conflict.returning(:id).multi_insert(attributes)
        end

        def create(attributes)
          locations.changeset(:create, **attributes).commit
        end

        def find_by_ip_address(ip_address)
          ip_address = IPAddr.new(ip_address).to_s
          locations.where(ip_address: ip_address).one
        rescue IPAddr::InvalidAddressError
          nil
        end

        def count
          locations.count
        end
      end
    end
  end
end
