# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::PowerZones do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#list" do
    it "returns power zones as models" do
      stub_request(:get, "https://api.wahooligan.com/v1/power_zones")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200,
                   body: [{ "id" => 1, "ftp" => 250, "zone_1" => 137 }].to_json)

      zones = client.power_zones.list

      expect(zones.first).to be_a(Wahoo::Models::PowerZone)
      expect(zones.first.ftp).to eq(250)
    end
  end

  describe "#get" do
    it "returns a single power zone" do
      stub_request(:get, "https://api.wahooligan.com/v1/power_zones/30")
        .to_return(status: 200, body: { "id" => 30, "ftp" => 280 }.to_json)

      zone = client.power_zones.get(30)
      expect(zone.ftp).to eq(280)
    end
  end

  describe "#create" do
    it "creates a power zone wrapping params" do
      stub = stub_request(:post, "https://api.wahooligan.com/v1/power_zones")
        .with(body: hash_including("power_zone" => hash_including("ftp" => 300)))
        .to_return(status: 200, body: { "id" => 50, "ftp" => 300 }.to_json)

      zone = client.power_zones.create(ftp: 300, zone_1: 100, workout_type_id: 0)

      expect(zone.ftp).to eq(300)
      expect(stub).to have_been_requested
    end
  end

  describe "#update" do
    it "updates a power zone" do
      stub = stub_request(:put, "https://api.wahooligan.com/v1/power_zones/30")
        .with(body: hash_including("power_zone" => hash_including("ftp" => 320)))
        .to_return(status: 200, body: { "id" => 30, "ftp" => 320 }.to_json)

      zone = client.power_zones.update(30, ftp: 320)

      expect(zone.ftp).to eq(320)
      expect(stub).to have_been_requested
    end
  end

  describe "#delete" do
    it "deletes a power zone" do
      stub = stub_request(:delete, "https://api.wahooligan.com/v1/power_zones/30")
        .to_return(status: 200, body: "{}")

      client.power_zones.delete(30)
      expect(stub).to have_been_requested
    end
  end
end