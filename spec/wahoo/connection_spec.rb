# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Connection do
  let(:connection) { described_class.new(access_token: "test_token") }

  describe "#get" do
    it "returns the parsed body on success" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(
          status: 200,
          body: { "id" => 1, "first" => "Silviu" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      response = connection.get("/v1/user")

      expect(response.body).to eq({ "id" => 1, "first" => "Silviu" })
    end

    it "sends the Bearer token in the Authorization header" do
      stub = stub_request(:get, "https://api.wahooligan.com/v1/user")
        .with(headers: { "Authorization" => "Bearer test_token" })
        .to_return(status: 200, body: "{}")

      connection.get("/v1/user")

      expect(stub).to have_been_requested
    end

    it "passes query params" do
      stub = stub_request(:get, "https://api.wahooligan.com/v1/workouts")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200, body: "{}")

      connection.get("/v1/workouts", page: 1, per_page: 30)

      expect(stub).to have_been_requested
    end

    it "raises Unauthorized on 401" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(status: 401, body: { "error" => "bad token" }.to_json)

      expect { connection.get("/v1/user") }.to raise_error(Wahoo::Unauthorized)
    end

    it "raises NotFound on 404" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts/999")
        .to_return(status: 404, body: { "error" => "not found" }.to_json)

      expect { connection.get("/v1/workouts/999") }.to raise_error(Wahoo::NotFound)
    end
  end

  describe "rate limit headers" do
    it "exposes rate limit info from the response" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(
          status: 200,
          body: "{}",
          headers: {
            "X-RateLimit-Limit" => "5000, 1000, 200",
            "X-RateLimit-Remaining" => "4999, 999, 199"
          }
        )

      response = connection.get("/v1/user")

      expect(response.rate_limit).to eq({ day: 5000, hour: 1000, five_min: 200 })
      expect(response.rate_limit_remaining).to eq({ day: 4999, hour: 999, five_min: 199 })
    end
  end
end