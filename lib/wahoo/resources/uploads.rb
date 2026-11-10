# frozen_string_literal: true

module Wahoo
  module Resources
    class Uploads < Base
      def create(file:, filename: "workout.fit", time_zone: nil,
                 workout_name: nil, target_workout_id: nil)
        body = {
          workout_file_upload: {
            file: file_data_uri(file, "application/vnd.fit"),
            filename: filename,
            time_zone: time_zone,
            workout_name: workout_name,
            target_workout_id: target_workout_id
          }.compact
        }
        post_model("/v1/workout_file_uploads", body, model: Models::WorkoutFileUpload)
      end

      def get(token)
        get_one("/v1/workout_file_uploads/#{token}", model: Models::WorkoutFileUpload)
      end
    end
  end
end
