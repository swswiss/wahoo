# frozen_string_literal: true

module Wahoo
  module Webhooks
    module Handler
      module_function

      def parse(raw_body)
        data = raw_body.is_a?(String) ? JSON.parse(raw_body) : raw_body
        Event.new(data)
      end

      def verify_token!(raw_body)
        data = raw_body.is_a?(String) ? JSON.parse(raw_body) : raw_body
        expected = Wahoo.configuration.webhook_secret
        return parse(data) if expected.nil?

        token = data["webhook_token"]
        unless token && secure_compare(token.to_s, expected.to_s)
          raise Wahoo::Unauthorized.new("Webhook token invalid")
        end
        parse(data)
      end

      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize
        if OpenSSL.respond_to?(:fixed_length_secure_compare)
          OpenSSL.fixed_length_secure_compare(a, b)
        else
          require "securerandom"
          Rack::Utils.secure_compare(a, b) rescue (a == b)
        end
      end
    end
  end
end
