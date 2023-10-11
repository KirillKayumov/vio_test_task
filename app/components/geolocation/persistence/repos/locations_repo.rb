module Geolocation
  module Persistence
    module Repos
      class LocationsRepo < ROM::Repository[:locations]
        def import(attributes)
          locations.dataset.insert_conflict.returning(:id).multi_insert(attributes)
        end
      end
    end
  end
end
