# frozen_string_literal: true

module Wahoo
  class Error < StandardError
    attr_reader :status, :body

    def initialize(message, status: nil, body: nil)
      @status = status
      @body = body
      super(message)
    end

    def self.from(status, body)
      message =
        if body.is_a?(Hash)
          body["error"] || body["errors"] || body["message"]
        else
          body.to_s
        end

      klass =
        case status
        when 400 then BadRequest
        when 401 then Unauthorized
        when 403 then Forbidden
        when 404 then NotFound
        when 405 then MethodNotAllowed
        when 406 then NotAcceptable
        when 410 then Gone
        when 422 then UnprocessableEntity
        when 429 then RateLimited
        when 500..599 then ServerError
        else Error
        end

      klass.new(message || "Wahoo API error (#{status})", status: status, body: body)
    end
  end

  class BadRequest < Error; end
  class Unauthorized < Error; end
  class Forbidden < Error; end
  class NotFound < Error; end
  class MethodNotAllowed < Error; end
  class NotAcceptable < Error; end
  class Gone < Error; end
  class UnprocessableEntity < Error; end
  class ServerError < Error; end
  class ConfigurationError < Error; end

  class RateLimited < Error
    attr_accessor :retry_after
  end
end
