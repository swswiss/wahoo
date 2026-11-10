# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::Plans do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#list" do
    it "returns plans as models" do
      stub_request(:get, "https://api.wahooligan.com/v1/plans")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200,
                   body: [{ "id" => 1, "name" => "Plan A", "external_id" => "e1" }].to_json)

      plans = client.plans.list

      expect(plans.first).to be_a(Wahoo::Models::Plan)
      expect(plans.first.name).to eq("Plan A")
    end
  end

  describe "#get" do
    it "returns a single plan" do
      stub_request(:get, "https://api.wahooligan.com/v1/plans/20")
        .to_return(status: 200, body: { "id" => 20, "name" => "Plan B" }.to_json)

      plan = client.plans.get(20)
      expect(plan.name).to eq("Plan B")
    end
  end

  describe "#create" do
    it "sends the plan file as a base64 data-uri" do
      file = Tempfile.new(["plan", ".json"])
      file.write('{"workouts":[]}')
      file.rewind

      stub = stub_request(:post, "https://api.wahooligan.com/v1/plans")
        .with { |req|
          body = JSON.parse(req.body)
          body["plan"]["file"].start_with?("data:application/json;base64,") &&
            body["plan"]["external_id"] == "p1"
        }
        .to_return(status: 200, body: { "id" => 60, "external_id" => "p1" }.to_json)

      plan = client.plans.create(
        file: file.path, external_id: "p1",
        provider_updated_at: "2026-08-22T08:00:00Z"
      )

      expect(plan.id).to eq(60)
      expect(stub).to have_been_requested

      file.close
      file.unlink
    end
  end

  describe "#delete" do
    it "deletes a plan" do
      stub = stub_request(:delete, "https://api.wahooligan.com/v1/plans/20")
        .to_return(status: 200, body: "{}")

      client.plans.delete(20)
      expect(stub).to have_been_requested
    end
  end
end