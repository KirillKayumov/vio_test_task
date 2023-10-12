describe Geolocation::Importer do
  subject(:call) { described_class.new(filepath: filepath).call }

  let(:filepath) { "spec/fixtures/locations.csv" }

  it "works" do
    expect(call).to match(accepted_count: 4, rejected_count: 1, time_elapsed: kind_of(Float))
  end
end
