# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Error do
  describe ".from" do
    it "returns Unauthorized for 401" do
      error = Wahoo::Error.from(401, { "error" => "bad token" })

      expect(error).to be_a(Wahoo::Unauthorized)
      expect(error.status).to eq(401)
    end

    it "returns NotFound for 404" do
      error = Wahoo::Error.from(404, { "error" => "missing" })
      expect(error).to be_a(Wahoo::NotFound)
    end

    it "returns RateLimited for 429" do
      error = Wahoo::Error.from(429, { "error" => "slow down" })
      expect(error).to be_a(Wahoo::RateLimited)
    end

    it "returns UnprocessableEntity for 422" do
      error = Wahoo::Error.from(422, { "error" => "invalid" })
      expect(error).to be_a(Wahoo::UnprocessableEntity)
    end

    it "returns ServerError for 500" do
      error = Wahoo::Error.from(500, { "error" => "oops" })
      expect(error).to be_a(Wahoo::ServerError)
    end

    it "falls back to base Error for unknown status" do
      error = Wahoo::Error.from(418, { "error" => "teapot" })
      expect(error).to be_a(Wahoo::Error)
    end

    it "extracts the message from the body" do
      error = Wahoo::Error.from(401, { "error" => "bad token" })
      expect(error.message).to eq("bad token")
    end

    it "keeps the raw body" do
      body = { "error" => "nope" }
      error = Wahoo::Error.from(403, body)
      expect(error.body).to eq(body)
    end
  end
end