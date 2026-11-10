# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::Routes do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#list" do
    it "returns routes as models (array response, no root)" do
      stub_request(:get, "https://api.wahooligan.com/v1/routes")
        .with(query: { page: 1, per_page: 30 })
        .to_return(
          status: 200,
          body: [
            { "id" => 1, "name" => "Tur Copou", "distance" => "45230.50" }
          ].to_json
        )

      routes = client.routes.list

      expect(routes.first).to be_a(Wahoo::Models::Route)
      expect(routes.first.name).to eq("Tur Copou")
      expect(routes.first.distance_km).to eq(45.23)
    end
  end

  describe "#get" do
    it "returns a single route" do
      stub_request(:get, "https://api.wahooligan.com/v1/routes/10")
        .to_return(status: 200, body: { "id" => 10, "name" => "Route X" }.to_json)

      route = client.routes.get(10)
      expect(route.name).to eq("Route X")
    end
  end

  describe "#create" do
    it "sends the file as a base64 data-uri" do
      # un fișier temporar de test
      file = Tempfile.new(["route", ".fit"])
      file.write("FIT_FILE_CONTENT")
      file.rewind

      stub = stub_request(:post, "https://api.wahooligan.com/v1/routes")
        .with { |req|
          body = JSON.parse(req.body)
          # verificăm că fișierul e trimis ca data-uri base64
          body["route"]["file"].start_with?("data:application/vnd.fit;base64,") &&
            body["route"]["name"] == "My route"
        }
        .to_return(status: 200, body: { "id" => 50, "name" => "My route" }.to_json)

      route = client.routes.create(
        file: file.path, external_id: "r1",
        provider_updated_at: "2026-08-22T08:00:00Z", name: "My route",
        start_lat: 47.15, start_lng: 27.60, distance: 45000, ascent: 340
      )

      expect(route.id).to eq(50)
      expect(stub).to have_been_requested

      file.close
      file.unlink
    end
  end

  describe "#update" do
    it "updates a route" do
      stub = stub_request(:put, "https://api.wahooligan.com/v1/routes/10")
        .with(body: hash_including("route" => hash_including("name" => "Renamed")))
        .to_return(status: 200, body: { "id" => 10, "name" => "Renamed" }.to_json)

      route = client.routes.update(10, name: "Renamed")
      expect(route.name).to eq("Renamed")
      expect(stub).to have_been_requested
    end
  end

  describe "#delete" do
    it "deletes a route" do
      stub = stub_request(:delete, "https://api.wahooligan.com/v1/routes/10")
        .to_return(status: 200, body: "{}")

      client.routes.delete(10)
      expect(stub).to have_been_requested
    end
  end
end