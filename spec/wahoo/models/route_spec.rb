# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Models::Route do
  let(:route) do
    described_class.new(
      "id" => 10,
      "user_id" => 5,
      "name" => "Tur Copou",
      "description" => "Tură relaxată",
      "distance" => "45230.50",
      "ascent" => "340.00",
      "descent" => "320.00",
      "start_lat" => 47.17,
      "start_lng" => 27.57,
      "file" => { "url" => "https://cdn.wahoo.com/route.fit" }
    )
  end

  it "exposes basic fields" do
    expect(route.id).to eq(10)
    expect(route.name).to eq("Tur Copou")
    expect(route.description).to eq("Tură relaxată")
  end

  it "exposes the file url" do
    expect(route.file_url).to eq("https://cdn.wahoo.com/route.fit")
  end

  it "converts distance from string to km" do
    expect(route.distance_km).to eq(45.23)
  end

  it "converts ascent to feet" do
    expect(route.ascent_feet).to eq(1115)
  end
end