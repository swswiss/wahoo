# frozen_string_literal: true

module Wahoo
  module Conversions
    module_function

    def to_f_or_nil(v)
      return nil if v.nil? || v.to_s.strip.empty?
      v.to_f
    end

    def meters_to_km(m)
      v = to_f_or_nil(m); v && (v / 1000).round(2)
    end

    def meters_to_miles(m)
      v = to_f_or_nil(m); v && (v / 1609.344).round(2)
    end

    def meters_to_feet(m)
      v = to_f_or_nil(m); v && (v * 3.28084).round(0).to_i
    end

    def seconds_to_minutes(s)
      v = to_f_or_nil(s); v && (v / 60).round(1)
    end

    def seconds_to_hours(s)
      v = to_f_or_nil(s); v && (v / 3600).round(2)
    end

    def seconds_to_human(s)
      v = to_f_or_nil(s); return nil unless v
      v = v.to_i
      h = v / 3600
      m = (v % 3600) / 60
      sec = v % 60
      parts = []
      parts << "#{h}h" if h.positive?
      parts << "#{m}m" if m.positive? || h.positive?
      parts << "#{sec}s"
      parts.join(" ")
    end

    def mps_to_kmh(mps)
      v = to_f_or_nil(mps); v && (v * 3.6).round(1)
    end

    def mps_to_mph(mps)
      v = to_f_or_nil(mps); v && (v * 2.236936).round(1)
    end

    def mps_to_pace_per_km(mps)
      v = to_f_or_nil(mps); return nil if v.nil? || v <= 0
      spk = 1000.0 / v
      min = (spk / 60).floor
      sec = (spk % 60).round
      if sec == 60
        min += 1; sec = 0
      end
      format("%d:%02d /km", min, sec)
    end
  end
end
