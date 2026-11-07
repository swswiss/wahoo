# frozen_string_literal: true

require "faraday"
require "json"

require_relative "wahoo/version"
require_relative "wahoo/configuration"
require_relative "wahoo/error"
require_relative "wahoo/connection"
require_relative "wahoo/oauth"
require_relative "wahoo/models/base"

module Wahoo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset!
      @configuration = Configuration.new
    end
  end
end
