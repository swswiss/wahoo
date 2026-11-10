# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Resources::Permissions do
  let(:client) { Wahoo::Client.new(access_token: "fake_token") }

  describe "#revoke" do
    it "deauthorizes the app" do
      stub = stub_request(:delete, "https://api.wahooligan.com/v1/permissions")
        .with(headers: { "Authorization" => "Bearer fake_token" })
        .to_return(status: 200, body: "{}")

      client.permissions.revoke

      expect(stub).to have_been_requested
    end
  end

  describe "client shortcut" do
    it "can deauthorize via client.deauthorize" do
      stub = stub_request(:delete, "https://api.wahooligan.com/v1/permissions")
        .to_return(status: 200, body: "{}")

      client.deauthorize

      expect(stub).to have_been_requested
    end
  end
end