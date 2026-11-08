# frozen_string_literal: true

module Wahoo
  module Models
    class PowerZone < Base
      property :id
      property :user_id
      property :zone_1
      property :zone_2
      property :zone_3
      property :zone_4
      property :zone_5
      property :zone_6
      property :zone_7
      property :zone_count
      property :ftp
      property :critical_power
      property :workout_type_id
      property :workout_type_family_id
      property :workout_type_location_id
      property :originator_type
      property :fitness_app_id
      property :created_at, as: :time
      property :updated_at, as: :time
    end
  end
end
