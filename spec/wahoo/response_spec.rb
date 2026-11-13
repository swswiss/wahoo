# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Response do
  describe "#rate_limit" do
    it "parses the three rate limit windows (day, hour, 5min)" do
      response = described_class.new(
        body: {},
        headers: { "x-ratelimit-limit" => "5000, 1000, 200" }
      )

      expect(response.rate_limit).to eq({ day: 5000, hour: 1000, five_min: 200 })
    end

    it "returns nil when the header is absent" do
      response = described_class.new(body: {}, headers: {})
      expect(response.rate_limit).to be_nil
    end
  end

  describe "#rate_limit_remaining" do
    it "parses the remaining windows" do
      response = described_class.new(
        body: {},
        headers: { "x-ratelimit-remaining" => "4999, 999, 199" }
      )

      expect(response.rate_limit_remaining).to eq({ day: 4999, hour: 999, five_min: 199 })
    end
  end

  describe "#rate_limit_reset" do
    it "returns the reset seconds" do
      response = described_class.new(
        body: {},
        headers: { "x-ratelimit-reset" => "120" }
      )

      expect(response.rate_limit_reset).to eq(120)
    end
  end
end