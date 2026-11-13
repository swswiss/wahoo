# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Webhooks::Event do
  let(:payload) do
    {
      "event_type" => "workout_summary",
      "webhook_token" => "secret123",
      "user" => { "id" => 60462 },
      "workout_summary" => {
        "id" => 8297,
        "distance_accum" => "24909.71",
        "ascent_accum" => "450.00",
        "workout" => {
          "id" => 56519,
          "name" => "Friday Fun",
          "workout_type_id" => 0
        }
      }
    }
  end

  let(:event) { described_class.new(payload) }

  it "exposes the event type" do
    expect(event.event_type).to eq("workout_summary")
  end

  it "recognizes a workout_summary event" do
    expect(event.workout_summary?).to be(true)
  end

  it "extracts the user id from the nested user object" do
    expect(event.user_id).to eq(60462)
  end

  it "exposes the workout summary as a model" do
    expect(event.workout_summary).to be_a(Wahoo::Models::WorkoutSummary)
    expect(event.workout_summary.distance_km).to eq(24.91)
  end

  it "extracts the nested workout" do
    workout = event.workout
    expect(workout).to be_a(Wahoo::Models::Workout)
    expect(workout.name).to eq("Friday Fun")
    expect(workout.id).to eq(56519)
  end

  it "returns nil workout when there is no nested workout" do
    event = described_class.new(
      "event_type" => "workout_summary",
      "workout_summary" => { "id" => 1 }
    )
    expect(event.workout).to be_nil
  end
end