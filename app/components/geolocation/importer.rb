require 'csv'

module Geolocation
  class Importer
    BATCH_SIZE = 1000

    def initialize(filepath:, batch_size: BATCH_SIZE, repo: Persistence::Repos::LocationsRepo.new(Config.rom))
      @filepath = filepath
      @batch_size = batch_size
      @repo = repo
    end

    def call
      stats, time_elapsed = measure_time do
        CSV.foreach(@filepath, headers: true).each_slice(@batch_size).reduce(initial_stats) do |acc, rows_batch|
          valid_locations = rows_batch.filter_map do |row|
            validate_row(row).then { |result| result.to_h if result.success? }
          end

          imported_ids = @repo.import(valid_locations)

          acc[:accepted_count] += imported_ids.size
          acc[:rejected_count] += rows_batch.size - imported_ids.size
          acc
        end
      end

      stats.merge(time_elapsed: time_elapsed)
    end

    private

    def initial_stats
      { accepted_count: 0, rejected_count: 0, time_elapsed: 0 }
    end

    def validate_row(row)
      ImportLocationContract.new.call(
        ip_address: row['ip_address'],
        country_code: row['country_code'],
        country: row['country'],
        city: row['city'],
        latitude: row['latitude'],
        longitude: row['longitude'],
        created_at: Time.now,
        updated_at: Time.now
      )
    end

    def measure_time
      start_time = Time.now
      result = yield
      end_time = Time.now

      [result, end_time - start_time]
    end
  end
end
