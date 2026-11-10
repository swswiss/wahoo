# frozen_string_literal: true

module Wahoo
  module Resources
    class Plans < Base
      def list(external_id: nil, per_page: nil, limit: nil)
        params = external_id ? { external_id: external_id } : {}
        paginate("/v1/plans", model: Models::Plan, root: nil,
                 per_page: per_page, limit: limit, **params)
      end

      def get(id)
        get_one("/v1/plans/#{id}", model: Models::Plan)
      end

      def create(file:, external_id:, provider_updated_at:, filename: "plan.json", **extra)
        body = {
          plan: {
            file: file_data_uri(file, "application/json"),
            filename: filename,
            external_id: external_id,
            provider_updated_at: provider_updated_at
          }.merge(extra)
        }
        post_model("/v1/plans", body, model: Models::Plan)
      end

      def update(id, **attrs)
        put_model("/v1/plans/#{id}", { plan: attrs }, model: Models::Plan)
      end

      def delete(id)
        delete_path("/v1/plans/#{id}")
      end
    end
  end
end
