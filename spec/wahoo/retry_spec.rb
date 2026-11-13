# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Wahoo::Connection automatic retries" do
  let(:connection) { Wahoo::Connection.new(access_token: "t") }

  before do
    Wahoo.configuration.max_retries = 3
    Wahoo.configuration.retry_backoff = 0
  end

  describe "on 429 (rate limited)" do
    it "retries then succeeds" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(
          { status: 429, body: { "error" => "slow down" }.to_json,
            headers: { "X-RateLimit-Reset" => "0" } },
          { status: 200, body: { "id" => 1 }.to_json }
        )

      response = connection.get("/v1/user")

      expect(response.body).to eq({ "id" => 1 })
    end

    it "gives up after max_retries and raises" do
      Wahoo.configuration.max_retries = 2

      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(status: 429, body: { "error" => "slow" }.to_json,
                   headers: { "X-RateLimit-Reset" => "0" })

      expect { connection.get("/v1/user") }.to raise_error(Wahoo::RateLimited)
    end
  end

  describe "on 5xx (server error)" do
    it "retries then succeeds" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(
          { status: 503, body: { "error" => "unavailable" }.to_json },
          { status: 200, body: { "id" => 1 }.to_json }
        )

      response = connection.get("/v1/user")
      expect(response.body).to eq({ "id" => 1 })
    end
  end

  describe "on other errors (no retry)" do
    it "does NOT retry on 401" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(status: 401, body: { "error" => "bad token" }.to_json)

      expect { connection.get("/v1/user") }.to raise_error(Wahoo::Unauthorized)
    end
  end
end