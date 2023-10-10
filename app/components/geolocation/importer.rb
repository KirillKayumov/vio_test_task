require 'csv'

module Geolocation
  class Importer
    BATCH_SIZE = 1000

    def initialize(filepath:, batch_size: BATCH_SIZE)
      @filepath = filepath
      @batch_size = batch_size
    end

    def call
      acc = { accepted_count: 0, rejected_count: 0, time_elapsed: 0 }
      start_time = Time.now

      acc = CSV.foreach(@filepath, headers: true).each_slice(@batch_size).reduce(acc) do |acc, rows_batch|
        valid_locations =
          rows_batch
            .filter_map do |row|
              location = Location.new(
                ip_address: row['ip_address'],
                country_code: row['country_code'],
                country: row['country'],
                city: row['city'],
                latitude: row['latitude'],
                longitude: row['longitude']
              )

              location if location.valid?
            end
            .map { |location| location.slice(:ip_address, :country_code, :country, :city, :latitude, :longitude) }

        begin
          result = Location.upsert_all(valid_locations, unique_by: :ip_address, on_duplicate: :skip)
        rescue Exception => e
          :ok
        end

        acc[:accepted_count] += result.rows.size
        acc[:rejected_count] += rows_batch.size - result.rows.size
        acc
      end

      end_time = Time.now

      acc.merge(time_elapsed: end_time - start_time)
    end
  end
end
