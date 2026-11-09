# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::User do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#get" do
    it "returns the user profile as a model" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .with(headers: { "Authorization" => "Bearer fake_token" })
        .to_return(
          status: 200,
          body: {
            "id" => 60462,
            "first" => "Silviu",
            "last" => "Stefanache",
            "email" => "silviu@example.com",
            "gender" => 0
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      user = client.user.get

      expect(user).to be_a(Wahoo::Models::User)
      expect(user.name).to eq("Silviu Stefanache")
      expect(user.email).to eq("silviu@example.com")
      expect(user.gender_label).to eq("male")
    end
  end

  describe "#update" do
    it "updates the user and returns the updated model" do
      stub = stub_request(:put, "https://api.wahooligan.com/v1/user")
        .with(body: hash_including("user" => hash_including("weight" => 72)))
        .to_return(
          status: 200,
          body: { "id" => 60462, "first" => "Silviu", "weight" => "72.0" }.to_json
        )

      user = client.user.update(weight: 72)

      expect(user).to be_a(Wahoo::Models::User)
      expect(stub).to have_been_requested
    end
  end
end