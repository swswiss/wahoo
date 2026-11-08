# frozen_string_literal: true

require "faraday"
require "json"

require_relative "wahoo/version"
require_relative "wahoo/configuration"
require_relative "wahoo/error"
require_relative "wahoo/connection"
require_relative "wahoo/oauth"
require_relative "wahoo/conversions"

require_relative "wahoo/models/base"
require_relative "wahoo/models/workout"
require_relative "wahoo/models/route"
require_relative "wahoo/models/user"
require_relative "wahoo/models/power_zone"
require_relative "wahoo/models/plan"
require_relative "wahoo/models/workout_file_upload"

require_relative "wahoo/data/workout_types"

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
