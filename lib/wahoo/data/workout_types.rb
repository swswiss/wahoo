# frozen_string_literal: true

module Wahoo
  # Constante din documentație: tipuri de workout, locații, familii.
  # Folosești ex. Wahoo::Data::WORKOUT_TYPES[0] => "BIKING".
  module Data
    WORKOUT_TYPES = {
      0 => "BIKING", 1 => "RUNNING", 2 => "FE", 3 => "RUNNING_TRACK",
      4 => "RUNNING_TRAIL", 5 => "RUNNING_TREADMILL", 6 => "WALKING",
      7 => "WALKING_SPEED", 8 => "WALKING_NORDIC", 9 => "HIKING",
      10 => "MOUNTAINEERING", 11 => "BIKING_CYCLECROSS", 12 => "BIKING_INDOOR",
      13 => "BIKING_MOUNTAIN", 14 => "BIKING_RECUMBENT", 15 => "BIKING_ROAD",
      16 => "BIKING_TRACK", 17 => "BIKING_MOTOCYCLING", 18 => "FE_GENERAL",
      19 => "FE_TREADMILL", 20 => "FE_ELLIPTICAL", 21 => "FE_BIKE",
      22 => "FE_ROWER", 23 => "FE_CLIMBER", 25 => "SWIMMING_LAP",
      26 => "SWIMMING_OPEN_WATER", 27 => "SNOWBOARDING", 28 => "SKIING",
      29 => "SKIING_DOWNHILL", 30 => "SKIINGCROSS_COUNTRY", 31 => "SKATING",
      32 => "SKATING_ICE", 33 => "SKATING_INLINE", 34 => "LONG_BOARDING",
      35 => "SAILING", 36 => "WINDSURFING", 37 => "CANOEING", 38 => "KAYAKING",
      39 => "ROWING", 40 => "KITEBOARDING", 41 => "STAND_UP_PADDLE_BOARD",
      42 => "WORKOUT", 43 => "CARDIO_CLASS", 44 => "STAIR_CLIMBER",
      45 => "WHEELCHAIR", 46 => "GOLFING", 47 => "OTHER",
      49 => "BIKING_INDOOR_CYCLING_CLASS", 56 => "WALKING_TREADMILL",
      61 => "BIKING_INDOOR_TRAINER", 62 => "MULTISPORT", 63 => "TRANSITION",
      64 => "EBIKING", 65 => "TICKR_OFFLINE", 66 => "YOGA",
      67 => "RUNNING_RACE", 68 => "BIKING_INDOOR_VIRTUAL", 69 => "MENTAL_STRENGTH",
      70 => "HANDCYCLING", 71 => "RUNNING_INDOOR_VIRTUAL", 255 => "UNKNOWN"
    }.freeze

    WORKOUT_TYPE_LOCATIONS = {
      0 => "INDOOR", 1 => "OUTDOOR", 255 => "UNKNOWN"
    }.freeze

    WORKOUT_TYPE_FAMILIES = {
      0 => "BIKING", 1 => "RUNNING", 2 => "SWIMMING", 3 => "WATER SPORTS",
      4 => "SNOW SPORTS", 5 => "SKATING", 6 => "GYM", 9 => "WALKING",
      30 => "N/A", 31 => "OTHER", 255 => "UNKNOWN"
    }.freeze

    module_function

    def workout_type(id);          WORKOUT_TYPES[id]; end
    def workout_type_location(id); WORKOUT_TYPE_LOCATIONS[id]; end
    def workout_type_family(id);   WORKOUT_TYPE_FAMILIES[id]; end
  end
end
