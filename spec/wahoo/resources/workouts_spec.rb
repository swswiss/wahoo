# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::Workouts do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#list" do
    it "returns workouts as models (paginated)" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts")
        .with(query: { page: 1, per_page: 30 })
        .to_return(
          status: 200,
          body: {
            "workouts" => [
              { "id" => 1, "name" => "Morning Ride", "workout_type_id" => 0,
                "workout_summary" => { "distance_accum" => "45230.50" } }
            ],
            "total" => 1, "page" => 1, "per_page" => 30
          }.to_json
        )

      workouts = client.workouts.list

      expect(workouts.first).to be_a(Wahoo::Models::Workout)
      expect(workouts.first.name).to eq("Morning Ride")
      expect(workouts.first.distance_km).to eq(45.23)
    end

    it "follows multiple pages" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts")
        .with(query: { page: 1, per_page: 2 })
        .to_return(status: 200, body: { "workouts" => [{ "id" => 1 }, { "id" => 2 }] }.to_json)
      stub_request(:get, "https://api.wahooligan.com/v1/workouts")
        .with(query: { page: 2, per_page: 2 })
        .to_return(status: 200, body: { "workouts" => [{ "id" => 3 }] }.to_json)

      workouts = client.workouts.list(per_page: 2)
      expect(workouts.map(&:id)).to eq([1, 2, 3])
    end

    it "respects the limit" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 200,
                   body: { "workouts" => [{ "id" => 1 }, { "id" => 2 }, { "id" => 3 }] }.to_json)

      expect(client.workouts.list(limit: 2).size).to eq(2)
    end
  end

  describe "#get" do
    it "returns a single workout" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts/56519")
        .to_return(status: 200, body: { "id" => 56519, "name" => "Ride" }.to_json)

      workout = client.workouts.get(56519)

      expect(workout).to be_a(Wahoo::Models::Workout)
      expect(workout.id).to eq(56519)
    end
  end

  describe "#create" do
    it "creates a workout wrapping params under :workout" do
      stub = stub_request(:post, "https://api.wahooligan.com/v1/workouts")
        .with(body: hash_including(
          "workout" => hash_including("name" => "New Ride", "workout_type_id" => 0)
        ))
        .to_return(status: 200, body: { "id" => 100, "name" => "New Ride" }.to_json)

      workout = client.workouts.create(
        name: "New Ride", workout_token: "tok",
        workout_type_id: 0, starts: "2026-08-22T08:00:00Z", minutes: 60
      )

      expect(workout.id).to eq(100)
      expect(stub).to have_been_requested
    end
  end

  describe "#update" do
    it "updates a workout" do
      stub = stub_request(:put, "https://api.wahooligan.com/v1/workouts/5")
        .with(body: hash_including("workout" => hash_including("name" => "Renamed")))
        .to_return(status: 200, body: { "id" => 5, "name" => "Renamed" }.to_json)

      workout = client.workouts.update(5, name: "Renamed")

      expect(workout.name).to eq("Renamed")
      expect(stub).to have_been_requested
    end
  end

  describe "#delete" do
    it "deletes a workout" do
      stub = stub_request(:delete, "https://api.wahooligan.com/v1/workouts/5")
        .to_return(status: 200, body: "{}")

      client.workouts.delete(5)

      expect(stub).to have_been_requested
    end
  end

  describe "#plans" do
    it "returns the plans attached to a workout" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts/5/plans")
        .to_return(status: 200, body: [{ "id" => 1, "name" => "Plan A" }].to_json)

      plans = client.workouts.plans(5)

      expect(plans.first).to be_a(Wahoo::Models::Plan)
      expect(plans.first.name).to eq("Plan A")
    end
  end

  describe "#summary" do
    it "returns the workout summary" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts/5/workout_summary")
        .to_return(status: 200, body: { "id" => 8, "distance_accum" => "45230.50" }.to_json)

      summary = client.workouts.summary(5)

      expect(summary).to be_a(Wahoo::Models::WorkoutSummary)
      expect(summary.distance_km).to eq(45.23)
    end
  end

  describe "errors" do
    it "raises Unauthorized on 401" do
      stub_request(:get, "https://api.wahooligan.com/v1/workouts")
        .with(query: { page: 1, per_page: 30 })
        .to_return(status: 401, body: { "error" => "bad" }.to_json)

      expect { client.workouts.list }.to raise_error(Wahoo::Unauthorized)
    end

    it "raises UnprocessableEntity on 422 when creating with bad params" do
      stub_request(:post, "https://api.wahooligan.com/v1/workouts")
        .to_return(status: 422, body: { "error" => "missing param" }.to_json)

      expect {
        client.workouts.create(name: "x", workout_token: "t",
                               workout_type_id: 0, starts: "x", minutes: 1)
      }.to raise_error(Wahoo::UnprocessableEntity)
    end
  end
end