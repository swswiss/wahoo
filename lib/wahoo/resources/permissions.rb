# frozen_string_literal: true

module Wahoo
  module Resources
    class Permissions < Base
      def revoke
        @connection.delete("/v1/permissions").body
      end
    end
  end
end
