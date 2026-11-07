# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Conversions do
  it "converts meters to km and miles" do
    expect(described_class.meters_to_km(45230)).to eq(45.23)
    expect(described_class.meters_to_miles(1609.344)).to eq(1.0)
  end

  it "converts meters to feet" do
    expect(described_class.meters_to_feet(100)).to eq(328)
  end

  it "formats seconds as human duration" do
    expect(described_class.seconds_to_human(6012)).to eq("1h 40m 12s")
    expect(described_class.seconds_to_human(125)).to eq("2m 5s")
  end

  it "converts m/s to km/h and mph" do
    expect(described_class.mps_to_kmh(10)).to eq(36.0)
    expect(described_class.mps_to_mph(10)).to eq(22.4)
  end

  it "converts m/s to pace per km" do
    # 4.1667 m/s ≈ 4:00 /km
    expect(described_class.mps_to_pace_per_km(4.1667)).to eq("4:00 /km")
  end

  it "returns nil for nil inputs" do
    expect(described_class.meters_to_km(nil)).to be_nil
    expect(described_class.mps_to_pace_per_km(0)).to be_nil
  end
end

RSpec.describe Wahoo::Models::WorkoutSummary do
  it "exposes conversion helpers" do
    summary = described_class.new(
      "distance_accum" => 45230.0,
      "ascent_accum" => 340.0,
      "duration_active_accum" => 6012,
      "speed_avg" => 7.3
    )

    expect(summary.distance_km).to eq(45.23)
    expect(summary.ascent_feet).to eq(1115)
    expect(summary.duration_human).to eq("1h 40m 12s")
    expect(summary.speed_avg_kmh).to eq(26.3)
    expect(summary.speed_avg_pace_per_km).to match(%r{\d+:\d\d /km})
  end
end

RSpec.describe "string decimals (Wahoo returns strings)" do
  it "converts string decimals correctly" do
    expect(Wahoo::Conversions.meters_to_km("45230.50")).to eq(45.23)
    expect(Wahoo::Conversions.meters_to_feet("340.00")).to eq(1115)
    expect(Wahoo::Conversions.mps_to_kmh("7.30")).to eq(26.3)
  end
end
