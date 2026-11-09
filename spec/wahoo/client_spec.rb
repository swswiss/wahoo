# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Client do
  it "requires an access token" do
    expect { Wahoo::Client.new(access_token: nil) }.to raise_error(ArgumentError)
  end

  it "exposes resources" do
    client = Wahoo::Client.new(access_token: "t")
    expect(client.workouts).to be_a(Wahoo::Resources::Workouts)
    expect(client.routes).to be_a(Wahoo::Resources::Routes)
    expect(client.user).to be_a(Wahoo::Resources::User)
    expect(client.power_zones).to be_a(Wahoo::Resources::PowerZones)
  end

  describe "user profile" do
    it "returns a User model" do
      stub_request(:get, "https://api.wahooligan.com/v1/user")
        .to_return(status: 200,
                   body: { "id" => 9, "first" => "Silviu", "last" => "S", "email" => "s@x.ro" }.to_json)

      user = Wahoo::Client.new(access_token: "t").user.get

      expect(user).to be_a(Wahoo::Models::User)
      expect(user.name).to eq("Silviu S")
      expect(user.email).to eq("s@x.ro")
    end
  end
end
