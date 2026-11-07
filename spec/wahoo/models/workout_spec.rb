# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Models::Workout do
  describe "conversion helpers from string decimals" do
    let(:workout) do
      described_class.new(
        "id" => 1,
        "name" => "Morning Ride",
        "workout_type_id" => 0,
        "minutes" => 62,
        "workout_summary" => {
          "distance_accum" => "45230.50",      # STRING, cum trimite Wahoo
          "ascent_accum" => "340.00",          # STRING
          "duration_active_accum" => "6012.00", # STRING
          "speed_avg" => "7.30"                 # STRING
        }
      )
    end

    it "converts distance from string decimal to km" do
      expect(workout.distance_km).to eq(45.23)
    end

    it "converts distance from string decimal to miles" do
      expect(workout.distance_miles).to eq(28.1)
    end

    it "formats duration as human readable" do
      expect(workout.duration_human).to eq("1h 40m 12s")
    end

    it "converts average speed from string to km/h" do
      expect(workout.avg_speed_kmh).to eq(26.3)
    end
  end

  describe "basic fields" do
    let(:workout) do
      described_class.new("id" => 56519, "name" => "Ride", "workout_type_id" => 0)
    end

    it "exposes id and name" do
      expect(workout.id).to eq(56519)
      expect(workout.name).to eq("Ride")
    end

    it "maps workout_type_id to a label" do
      expect(workout.workout_type).to eq("BIKING")
    end

    it "is not completed without a summary" do
      expect(workout.completed?).to be(false)
    end
  end
end