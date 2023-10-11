require_dependency "geolocation/config"

database_url = if Rails.env.development?
  "postgres://localhost:5432/vio_development"
elsif Rails.env.test?
  "postgres://localhost:5432/vio_test"
else
  ENV.fetch("DATABASE_URL")
end

Geolocation::Config.database_url = database_url
