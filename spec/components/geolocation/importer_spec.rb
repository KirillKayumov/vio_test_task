describe Geolocation::Importer do
  subject(:call) { described_class.new(filepath: filepath).call }

  let(:filepath) { "spec/fixtures/locations.csv" }
  let(:actual_locations_count) { Geolocation::Persistence::Repos::LocationsRepo.new(Geolocation::Config.rom).count }

  it "imports locations data" do
    expect(call).to match(accepted_count: 4, rejected_count: 1, time_elapsed: kind_of(Float))
    expect(actual_locations_count).to eq(4)
  end
end
