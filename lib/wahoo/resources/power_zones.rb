# frozen_string_literal: true

module Wahoo
  module Resources
    class PowerZones < Base
      def list(per_page: nil, limit: nil)
        paginate("/v1/power_zones", model: Models::PowerZone, root: nil,
                 per_page: per_page, limit: limit)
      end

      def get(id)
        get_one("/v1/power_zones/#{id}", model: Models::PowerZone)
      end

      def create(**attrs)
        post_model("/v1/power_zones", { power_zone: attrs }, model: Models::PowerZone)
      end

      def update(id, **attrs)
        put_model("/v1/power_zones/#{id}", { power_zone: attrs }, model: Models::PowerZone)
      end

      def delete(id)
        delete_path("/v1/power_zones/#{id}")
      end
    end
  end
end
