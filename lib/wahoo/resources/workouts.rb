# frozen_string_literal: true

module Wahoo
  module Resources
    class Workouts < Base
      def list(per_page: nil, limit: nil)
        paginate("/v1/workouts", model: Models::Workout, root: "workouts",
                 per_page: per_page, limit: limit)
      end

      def get(id)
        get_one("/v1/workouts/#{id}", model: Models::Workout)
      end

      def create(**attrs)
        post_model("/v1/workouts", wrap(attrs), model: Models::Workout)
      end

      def update(id, **attrs)
        put_model("/v1/workouts/#{id}", wrap(attrs), model: Models::Workout)
      end

      def delete(id)
        delete_path("/v1/workouts/#{id}")
      end

      def plans(workout_id)
        @connection.get("/v1/workouts/#{workout_id}/plans").body.map { |h| Models::Plan.new(h) }
      end

      def summary(workout_id)
        get_one("/v1/workouts/#{workout_id}/workout_summary", model: Models::WorkoutSummary)
      end

      private

      def wrap(attrs) = { workout: attrs }
    end
  end
end
