# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Models::PowerZone do
  let(:power_zone) do
    described_class.new(
      "id" => 30,
      "user_id" => 5,
      "ftp" => 250,
      "critical_power" => 265,
      "zone_1" => 137,
      "zone_2" => 187,
      "zone_7" => 450,
      "zone_count" => 7,
      "workout_type_id" => 0
    )
  end

  it "exposes ftp and critical power" do
    expect(power_zone.ftp).to eq(250)
    expect(power_zone.critical_power).to eq(265)
  end

  it "exposes the zones" do
    expect(power_zone.zone_1).to eq(137)
    expect(power_zone.zone_7).to eq(450)
    expect(power_zone.zone_count).to eq(7)
  end
end