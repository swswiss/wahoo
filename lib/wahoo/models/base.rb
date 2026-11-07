# frozen_string_literal: true

module Wahoo
  module Models

    class Base
      attr_reader :raw

      def initialize(attributes = {})
        @raw = attributes || {}
      end

      def self.property(name, key: nil, as: nil)
        json_key = (key || name).to_s

        define_method(name) do
          value = @raw[json_key]
          return nil if value.nil?

          case as
          when nil   then value
          when :time then (Time.parse(value) rescue value)
          when :date then (Date.parse(value) rescue value)
          when Class then as.new(value)           
          when Proc  then as.call(value)          
          else value
          end
        end
      end

      def self.from(hash)
        return nil if hash.nil?
        new(hash)
      end

      def self.from_list(array)
        Array(array).map { |h| new(h) }
      end

      def [](key)
        @raw[key.to_s]
      end

      def to_h
        @raw
      end

      def inspect
        "#<#{self.class.name} #{@raw.inspect}>"
      end
    end
  end
end
