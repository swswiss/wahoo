# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Webhooks::Handler do
  let(:raw_payload) do
    {
      "event_type" => "workout_summary",
      "webhook_token" => "secret123",
      "user" => { "id" => 60462 },
      "workout_summary" => { "distance_accum" => "24909.71" }
    }.to_json
  end

  describe ".parse" do
    it "parses a raw JSON string into an Event" do
      event = described_class.parse(raw_payload)

      expect(event).to be_a(Wahoo::Webhooks::Event)
      expect(event.user_id).to eq(60462)
    end

    it "parses a hash directly" do
      event = described_class.parse(JSON.parse(raw_payload))
      expect(event.event_type).to eq("workout_summary")
    end
  end

  describe ".verify_token!" do
    it "returns the event when the token matches" do
      Wahoo.configuration.webhook_secret = "secret123"

      event = described_class.verify_token!(raw_payload)

      expect(event).to be_a(Wahoo::Webhooks::Event)
    end

    it "raises Unauthorized when the token does not match" do
      Wahoo.configuration.webhook_secret = "wrong_secret"

      expect {
        described_class.verify_token!(raw_payload)
      }.to raise_error(Wahoo::Unauthorized)
    end

    it "skips verification when no secret is configured" do
      Wahoo.configuration.webhook_secret = nil

      event = described_class.verify_token!(raw_payload)
      expect(event).to be_a(Wahoo::Webhooks::Event)
    end
  end
end