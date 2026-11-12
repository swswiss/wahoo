# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Data do
  describe "WORKOUT_TYPES" do
    it "maps known workout type ids to labels" do
      expect(Wahoo::Data::WORKOUT_TYPES[0]).to eq("BIKING")
      expect(Wahoo::Data::WORKOUT_TYPES[1]).to eq("RUNNING")
      expect(Wahoo::Data::WORKOUT_TYPES[15]).to eq("BIKING_ROAD")
      expect(Wahoo::Data::WORKOUT_TYPES[255]).to eq("UNKNOWN")
    end

    it "returns nil for an unknown id" do
      expect(Wahoo::Data::WORKOUT_TYPES[9999]).to be_nil
    end

    it "is frozen (cannot be modified accidentally)" do
      expect(Wahoo::Data::WORKOUT_TYPES).to be_frozen
    end
  end

  describe "WORKOUT_TYPE_LOCATIONS" do
    it "maps location ids" do
      expect(Wahoo::Data::WORKOUT_TYPE_LOCATIONS[0]).to eq("INDOOR")
      expect(Wahoo::Data::WORKOUT_TYPE_LOCATIONS[1]).to eq("OUTDOOR")
    end
  end

  describe "WORKOUT_TYPE_FAMILIES" do
    it "maps family ids" do
      expect(Wahoo::Data::WORKOUT_TYPE_FAMILIES[0]).to eq("BIKING")
      expect(Wahoo::Data::WORKOUT_TYPE_FAMILIES[1]).to eq("RUNNING")
    end
  end

  describe "helper methods" do
    it "looks up a workout type by id" do
      expect(Wahoo::Data.workout_type(0)).to eq("BIKING")
    end

    it "looks up a location by id" do
      expect(Wahoo::Data.workout_type_location(1)).to eq("OUTDOOR")
    end

    it "looks up a family by id" do
      expect(Wahoo::Data.workout_type_family(0)).to eq("BIKING")
    end
  end
end


RSpec.describe Wahoo::Models::Workout do
  describe "#workout_type" do
    it "maps workout_type_id to a label via data types" do
      workout = described_class.new("workout_type_id" => 0)
      expect(workout.workout_type).to eq("BIKING")
    end

    it "maps a road biking workout" do
      workout = described_class.new("workout_type_id" => 15)
      expect(workout.workout_type).to eq("BIKING_ROAD")
    end

    it "returns nil for a workout without a type id" do
      workout = described_class.new({})
      expect(workout.workout_type).to be_nil
    end
  end
end