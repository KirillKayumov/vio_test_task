module Geolocation
  class Config
    class << self
      attr_accessor :database_url

      def rom
        @rom ||= begin
          config = ROM::Configuration.new(:sql, database_url)
          config.register_relation(Persistence::Relations::Locations)
          ROM.container(config)
        end
      end
    end
  end
end
