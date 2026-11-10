# frozen_string_literal: true

require "wahoo"
require "tempfile"
require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.before(:each) do
    Wahoo.reset!
    Wahoo.configure do |c|
      c.client_id     = "test_id"
      c.client_secret = "test_secret"
      c.redirect_uri  = "https://test.app/callback"
    end
  end
end

def fixture(name)
  File.read(File.join(__dir__, "fixtures", "#{name}.json"))
end
