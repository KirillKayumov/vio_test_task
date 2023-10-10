describe "GET /location" do
  let(:response_body) { JSON.parse(response.body) }

  context "when ip_address parameter is NOT passed" do
    it "responds with correct error" do
      get "/location"

      expect(response.status).to eq(400)
      expect(response_body).to eq("error_code" => "missing_ip_address")
    end
  end

  context "when location is NOT found by passed ip_address" do
    it "responds with correct error" do
      get "/location", params: { ip_address: "127.0.0.1" }

      expect(response.status).to eq(404)
      expect(response_body).to eq("error_code" => "location_not_found")
    end
  end

  context "when location is found by passed ip_address" do
    before do
      Geolocation::Location.create!(
        ip_address: "127.0.0.1",
        country_code: "US",
        country: "United States",
        city: "San Francisco",
        latitude: 37.7749,
        longitude: -122.4194
      )
    end

    it "responds with location data" do
      get "/location", params: { ip_address: "127.0.0.1" }

      expect(response.status).to eq(200)
      expect(response_body).to eq(
        "city" => "San Francisco",
        "country" => "United States",
        "country_code" => "US",
        "latitude" => 37.7749,
        "longitude" => -122.4194,
      )
    end
  end
end
