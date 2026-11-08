# frozen_string_literal: true

module Wahoo
  module Models
    class WorkoutFileUpload < Base
      property :id
      property :user_id
      property :token
      property :status
      property :time_zone
      property :workout_id
      property :workout_summary_id
      property :workout_file_id
      property :workout_name
      property :error
      property :target_workout_id
      property :created_at, as: :time
      property :updated_at, as: :time

      def complete?; status == "complete"; end
      def error?;    status == "error"; end
      def duplicate?; status == "duplicate"; end
      def pending?;  %w[pending in_progress].include?(status); end
    end
  end
end
