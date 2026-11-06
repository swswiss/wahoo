# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::OAuth do
  before do
    Wahoo.configure do |c|
      c.client_id     = "my_id"
      c.client_secret = "my_secret"
      c.redirect_uri  = "https://myapp.com/callback"
    end
  end

  describe ".authorize_url" do
    it "builds a URL with the correct params" do
      url = described_class.authorize_url(scope: "user_read workouts_read")

      expect(url).to start_with("https://api.wahooligan.com/oauth/authorize")
      expect(url).to include("client_id=my_id")
      expect(url).to include("response_type=code")
      # redirect_uri și scope sunt URL-encoded, deci verificăm fragmente
      expect(url).to include("redirect_uri=https%3A%2F%2Fmyapp.com%2Fcallback")
      expect(url).to include("scope=user_read+workouts_read")
    end

    it "includes state when given" do
      url = described_class.authorize_url(scope: "user_read", state: "abc123")
      expect(url).to include("state=abc123")
    end
  end

  describe ".exchange_code" do
    it "exchanges a code for tokens" do
      stub_request(:post, "https://api.wahooligan.com/oauth/token")
        .to_return(
          status: 200,
          body: {
            "access_token" => "access_abc",
            "refresh_token" => "refresh_xyz",
            "expires_in" => 7200,
            "created_at" => 1_700_000_000
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      tokens = described_class.exchange_code("the_code")

      expect(tokens.access_token).to eq("access_abc")
      expect(tokens.refresh_token).to eq("refresh_xyz")
      expect(tokens.expires_in).to eq(7200)
    end

    it "sends the right params" do
      stub = stub_request(:post, "https://api.wahooligan.com/oauth/token")
        .with(body: hash_including(
          "grant_type" => "authorization_code",
          "code" => "the_code",
          "client_id" => "my_id",
          "client_secret" => "my_secret"
        ))
        .to_return(status: 200, body: { "access_token" => "x" }.to_json)

      described_class.exchange_code("the_code")

      expect(stub).to have_been_requested
    end

    it "raises on error response" do
      stub_request(:post, "https://api.wahooligan.com/oauth/token")
        .to_return(status: 401, body: { "error" => "invalid_grant" }.to_json)

      expect { described_class.exchange_code("bad") }.to raise_error(Wahoo::Unauthorized)
    end
  end

  describe ".refresh" do
    it "refreshes using the refresh token" do
      stub = stub_request(:post, "https://api.wahooligan.com/oauth/token")
        .with(body: hash_including(
          "grant_type" => "refresh_token",
          "refresh_token" => "refresh_xyz"
        ))
        .to_return(status: 200, body: { "access_token" => "new_access" }.to_json)

      tokens = described_class.refresh("refresh_xyz")

      expect(tokens.access_token).to eq("new_access")
      expect(stub).to have_been_requested
    end
  end

  describe "Tokens#expired?" do
    it "is not expired when recently created" do
      tokens = Wahoo::OAuth::Tokens.new(
        access_token: "x",
        expires_in: 7200,
        created_at: Time.now.to_i
      )
      expect(tokens.expired?).to be(false)
    end

    it "is expired when created long ago" do
      tokens = Wahoo::OAuth::Tokens.new(
        access_token: "x",
        expires_in: 7200,
        created_at: Time.now.to_i - 10_000   # acum 10000 secunde, mai mult decât expires_in
      )
      expect(tokens.expired?).to be(true)
    end
  end
end