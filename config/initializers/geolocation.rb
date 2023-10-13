require_dependency "geolocation/config"

default_database_url = if Rails.env.development?
  "postgres://localhost:5432/vio_development"
elsif Rails.env.test?
  "postgres://localhost:5432/vio_test"
end

Geolocation::Config.database_url = ENV.fetch('DATABASE_URL', default_database_url)
