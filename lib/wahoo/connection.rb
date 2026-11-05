# frozen_string_literal: true

module Wahoo
  class Connection
    def initialize(access_token:, max_retries: nil, retry_backoff: nil)
      @access_token = access_token
      @base_url = Wahoo.configuration.base_url
      @max_retries   = max_retries   || Wahoo.configuration.max_retries
      @retry_backoff = retry_backoff || Wahoo.configuration.retry_backoff
    end

    def get(path, params = {})
      with_retries { request(:get, path, params) }
    end

    def post(path, body = {})
      with_retries { request(:post, path, body) }
    end

    def put(path, body = {})
      with_retries { request(:put, path, body) }
    end

    def delete(path, params = {})
      with_retries { request(:delete, path, params) }
    end

    private

    def with_retries
      attempts = 0
      begin
        yield
      rescue Wahoo::RateLimited => e
        attempts += 1
        raise e if attempts > @max_retries
        sleep(e.retry_after || (@retry_backoff * attempts))
        retry
      rescue Wahoo::ServerError => e
        attempts += 1
        raise e if attempts > @max_retries
        sleep(@retry_backoff * attempts)
        retry
      end
    end

    def request(method, path, data)
      resp = conn.public_send(method) do |req|
        req.url(path)
        req.headers["Authorization"] = "Bearer #{@access_token}"
        req.headers["Accept"] = "application/json"
        if %i[get delete].include?(method)
          req.params = data
        else
          req.headers["Content-Type"] = "application/json"
          req.body = data.to_json
        end
      end
      handle(resp)
    end

    def handle(resp)
      parsed = resp.body.to_s.empty? ? {} : JSON.parse(resp.body)
      unless resp.success?
        error = Wahoo::Error.from(resp.status, parsed)
        if error.is_a?(Wahoo::RateLimited)
          error.retry_after = resp.headers["x-ratelimit-reset"]&.to_i
        end
        raise error
      end
      Response.new(body: parsed, headers: resp.headers)
    end

    def conn
      @conn ||= Faraday.new(url: @base_url)
    end
  end

  class Response
    attr_reader :body, :headers

    def initialize(body:, headers:)
      @body = body
      @headers = headers
    end

    def rate_limit
      parse_triple(headers["x-ratelimit-limit"])
    end

    def rate_limit_remaining
      parse_triple(headers["x-ratelimit-remaining"])
    end

    def rate_limit_reset
      headers["x-ratelimit-reset"]&.to_i
    end

    private

    def parse_triple(value)
      return nil unless value
      day, hour, five = value.split(",").map { |v| v.strip.to_i }
      { day: day, hour: hour, five_min: five }
    end
  end
end
