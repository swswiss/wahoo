# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Wahoo::OAuth PKCE" do
  before do
    Wahoo.configure do |c|
      c.client_id    = "my_id"
      c.redirect_uri = "https://myapp.com/callback"
    end
  end

  describe ".generate_code_verifier" do
    it "generates a random string" do
      v = Wahoo::OAuth.generate_code_verifier
      expect(v).to be_a(String)
      expect(v.length).to be >= 43        # minimul cerut de standardul PKCE
      expect(v).not_to include("=")        # fără padding
    end

    it "generates a different verifier each time" do
      v1 = Wahoo::OAuth.generate_code_verifier
      v2 = Wahoo::OAuth.generate_code_verifier
      expect(v1).not_to eq(v2)             # random de fiecare dată
    end
  end

  describe ".code_challenge_for" do
    it "produces a challenge from a verifier" do
      verifier = "test_verifier_12345"
      challenge = Wahoo::OAuth.code_challenge_for(verifier)

      expect(challenge).to be_a(String)
      expect(challenge).not_to include("=")
    end

    it "is deterministic — same verifier gives same challenge" do
      verifier = "fixed_verifier"
      c1 = Wahoo::OAuth.code_challenge_for(verifier)
      c2 = Wahoo::OAuth.code_challenge_for(verifier)
      expect(c1).to eq(c2)                 # același verifier → același challenge
    end

    it "different verifiers give different challenges" do
      c1 = Wahoo::OAuth.code_challenge_for("verifier_a")
      c2 = Wahoo::OAuth.code_challenge_for("verifier_b")
      expect(c1).not_to eq(c2)
    end
  end

  describe ".authorize_url with PKCE" do
    it "includes the code challenge" do
      url = Wahoo::OAuth.authorize_url(scope: "user_read", code_challenge: "abc123")
      expect(url).to include("code_challenge=abc123")
      expect(url).to include("code_challenge_method=S256")
    end
  end

  describe ".exchange_code with PKCE" do
    it "sends code_verifier instead of client_secret" do
      stub = stub_request(:post, "https://api.wahooligan.com/oauth/token")
        .with(body: hash_including("code_verifier" => "my_verifier"))
        .to_return(status: 200, body: { "access_token" => "x" }.to_json)

      Wahoo::OAuth.exchange_code("the_code", code_verifier: "my_verifier")

      expect(stub).to have_been_requested
    end
  end
end