# frozen_string_literal: true

module Wahoo
  module Resources
    class Routes < Base
      def list(external_id: nil, per_page: nil, limit: nil)
        params = external_id ? { external_id: external_id } : {}
        paginate("/v1/routes", model: Models::Route, root: nil,
                 per_page: per_page, limit: limit, **params)
      end

      def get(id)
        get_one("/v1/routes/#{id}", model: Models::Route)
      end

      def create(file:, external_id:, provider_updated_at:, name:, start_lat:,
                 start_lng:, distance:, ascent:, filename: "route.fit", **extra)
        body = {
          route: {
            file: file_data_uri(file, "application/vnd.fit"),
            filename: filename,
            external_id: external_id,
            provider_updated_at: provider_updated_at,
            name: name,
            start_lat: start_lat,
            start_lng: start_lng,
            distance: distance,
            ascent: ascent
          }.merge(extra)
        }
        post_model("/v1/routes", body, model: Models::Route)
      end

      def update(id, **attrs)
        put_model("/v1/routes/#{id}", { route: attrs }, model: Models::Route)
      end

      def delete(id)
        delete_path("/v1/routes/#{id}")
      end
    end
  end
end
