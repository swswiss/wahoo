# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Models::Plan do
  let(:plan) do
    described_class.new(
      "id" => 20,
      "user_id" => 5,
      "name" => "Plan 8 săptămâni",
      "description" => "Pregătire cursă",
      "external_id" => "ext_123",
      "deleted" => false,
      "file" => { "url" => "https://cdn.wahoo.com/plan.json" }
    )
  end

  it "exposes basic fields" do
    expect(plan.id).to eq(20)
    expect(plan.name).to eq("Plan 8 săptămâni")
    expect(plan.external_id).to eq("ext_123")
    expect(plan.deleted).to be(false)
  end

  it "exposes the file url" do
    expect(plan.file_url).to eq("https://cdn.wahoo.com/plan.json")
  end
end