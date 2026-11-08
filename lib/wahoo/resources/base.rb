# frozen_string_literal: true

module Wahoo
  module Resources
    class Base
      def initialize(connection)
        @connection = connection
      end

      private

      def paginate(path, model:, root: nil, per_page: nil, limit: nil, **params)
        per_page ||= Wahoo.configuration.default_per_page
        results = []
        page = 1

        loop do
          body = @connection.get(path, params.merge(page: page, per_page: per_page)).body
          items = root ? Array(body[root.to_s]) : Array(body)
          break if items.empty?

          results.concat(items.map { |h| model.new(h) })
          break if items.size < per_page
          break if limit && results.size >= limit
          page += 1
        end

        limit ? results.first(limit) : results
      end

      def get_one(path, model:)
        model.from(@connection.get(path).body)
      end

      def post_model(path, body, model:)
        model.from(@connection.post(path, body).body)
      end

      def put_model(path, body, model:)
        model.from(@connection.put(path, body).body)
      end

      def delete_path(path)
        @connection.delete(path).body
      rescue Wahoo::NotFound
        nil
      end

      def file_data_uri(file, mime)
        content = file.is_a?(String) ? File.binread(file) : file.read
        "data:#{mime};base64,#{[content].pack('m0')}"
      end
    end
  end
end
