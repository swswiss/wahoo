# frozen_string_literal: true

module Wahoo
  module Models
    class Plan < Base
      property :id
      property :user_id
      property :name
      property :description
      property :file
      property :workout_type_family_id
      property :workout_type_location_id
      property :external_id
      property :provider_updated_at, as: :time
      property :deleted
      property :created_at, as: :time
      property :updated_at, as: :time

      def file_url
        file.is_a?(Hash) ? file["url"] : nil
      end
    end
  end
end
