# frozen_string_literal: true

module Wahoo
  module Models
    class Route < Base
      property :id
      property :user_id
      property :name
      property :description
      property :file
      property :workout_type_family_id
      property :external_id
      property :provider_updated_at, as: :time
      property :deleted
      property :start_lat
      property :start_lng
      property :distance
      property :ascent
      property :descent
      property :created_at, as: :time
      property :updated_at, as: :time

      def file_url
        file.is_a?(Hash) ? file["url"] : nil
      end

      def distance_km;    Conversions.meters_to_km(distance); end
      def distance_miles; Conversions.meters_to_miles(distance); end
      def ascent_feet;    Conversions.meters_to_feet(ascent); end
      def descent_feet;   Conversions.meters_to_feet(descent); end
    end
  end
end
