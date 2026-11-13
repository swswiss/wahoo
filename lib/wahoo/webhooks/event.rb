# frozen_string_literal: true

module Wahoo
  module Webhooks
    class Event < Wahoo::Models::Base
      property :event_type
      property :webhook_token
      property :user, as: ->(h) { Wahoo::Models::User.from(h) }
      property :workout_summary, as: ->(h) { Wahoo::Models::WorkoutSummary.from(h) }

      def workout_summary?
        event_type.to_s == "workout_summary"
      end

      def user_id
        user&.id
      end

      def workout
        ws = raw["workout_summary"]
        return nil unless ws.is_a?(Hash) && ws["workout"]
        Wahoo::Models::Workout.from(ws["workout"])
      end
    end
  end
end
