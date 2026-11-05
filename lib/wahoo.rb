# frozen_string_literal: true

require "faraday"
require "json"

require_relative "wahoo/version"
require_relative "wahoo/configuration"
require_relative "wahoo/error"

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
