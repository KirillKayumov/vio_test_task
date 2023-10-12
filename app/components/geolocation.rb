module Geolocation
  def find_by_ip_address(ip_address)
    Persistence::Repos::LocationsRepo.new(Config.rom).find_by_ip_address(ip_address)
  end
  module_function :find_by_ip_address
end
