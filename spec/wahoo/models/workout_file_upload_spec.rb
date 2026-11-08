# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Models::WorkoutFileUpload do
  it "exposes status and token" do
    upload = described_class.new(
      "id" => 40,
      "token" => "abc_token",
      "status" => "pending"
    )

    expect(upload.token).to eq("abc_token")
    expect(upload.status).to eq("pending")
    expect(upload.pending?).to be(true)
    expect(upload.complete?).to be(false)
  end

  it "recognizes a completed upload" do
    upload = described_class.new("status" => "complete", "workout_id" => 999)

    expect(upload.complete?).to be(true)
    expect(upload.workout_id).to eq(999)
  end

  it "recognizes an error upload" do
    upload = described_class.new("status" => "error", "error" => "bad file")

    expect(upload.error?).to be(true)
    expect(upload.error).to eq("bad file")
  end
end