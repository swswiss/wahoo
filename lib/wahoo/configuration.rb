# frozen_string_literal: true

module Wahoo
  class Configuration
    attr_accessor :client_id, :client_secret, :redirect_uri, :base_url,
                  :default_per_page, :max_retries, :retry_backoff,
                  :webhook_secret

    def initialize
      @base_url = "https://api.wahooligan.com"
      @default_per_page = 30
      @max_retries = 3
      @retry_backoff = 2
    end
  end
end
