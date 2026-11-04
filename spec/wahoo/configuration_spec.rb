# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wahoo::Configuration do
  it "has sensible defaults" do
    config = Wahoo::Configuration.new

    expect(config.base_url).to eq("https://api.wahooligan.com")
    expect(config.default_per_page).to eq(30)
  end

  it "can be configured via Wahoo.configure" do
    Wahoo.configure do |c|
      c.client_id     = "my_id"
      c.client_secret = "my_secret"
      c.redirect_uri  = "https://myapp.com/callback"
    end

    expect(Wahoo.configuration.client_id).to eq("my_id")
    expect(Wahoo.configuration.client_secret).to eq("my_secret")
    expect(Wahoo.configuration.redirect_uri).to eq("https://myapp.com/callback")
  end
end