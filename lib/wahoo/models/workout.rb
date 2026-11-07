# frozen_string_literal: true

module Wahoo
  module Models
    class Workout < Base
      property :id
      property :name
      property :starts, as: :time
      property :minutes
      property :day_code
      property :plan_id
      property :plan_ids             
      property :route_id
      property :workout_token
      property :workout_type_id
      property :created_at, as: :time
      property :updated_at, as: :time
      property :workout_summary, as: ->(h) { WorkoutSummary.from(h) }

      def workout_type
        Wahoo::Data::WORKOUT_TYPES[workout_type_id]
      end

      def completed?
        !workout_summary.nil?
      end

      def distance_km;    workout_summary&.distance_km; end
      def distance_miles; workout_summary&.distance_miles; end
      def duration_human; workout_summary&.duration_human; end
      def avg_speed_kmh;  workout_summary&.speed_avg_kmh; end
      def avg_pace_per_km; workout_summary&.speed_avg_pace_per_km; end
    end

    class WorkoutSummary < Base
      property :id
      property :name
      property :ascent_accum             # metri
      property :cadence_avg              # rpm
      property :calories_accum           # kCal
      property :distance_accum           # metri
      property :duration_active_accum    # secunde
      property :duration_paused_accum    # secunde
      property :duration_total_accum     # secunde
      property :heart_rate_avg           # bpm
      property :power_bike_np_last       # watts (normalized power)
      property :power_bike_tss_last      # unitless (TSS)
      property :power_avg                # watts
      property :speed_avg                # m/s
      property :work_accum               # joules
      property :time_zone
      property :manual
      property :edited
      property :fitness_app_id
      property :file                     # { "url" => "...fit" }
      property :created_at, as: :time
      property :updated_at, as: :time

      def file_url
        file.is_a?(Hash) ? file["url"] : nil
      end

      def distance_km;   Conversions.meters_to_km(distance_accum); end
      def distance_miles; Conversions.meters_to_miles(distance_accum); end
      def ascent_feet;   Conversions.meters_to_feet(ascent_accum); end
      def duration_minutes; Conversions.seconds_to_minutes(duration_active_accum); end
      def duration_hours;  Conversions.seconds_to_hours(duration_active_accum); end
      def duration_human;  Conversions.seconds_to_human(duration_active_accum); end
      def speed_avg_kmh;  Conversions.mps_to_kmh(speed_avg); end
      def speed_avg_mph;  Conversions.mps_to_mph(speed_avg); end
      def speed_avg_pace_per_km; Conversions.mps_to_pace_per_km(speed_avg); end
    end
  end
end
