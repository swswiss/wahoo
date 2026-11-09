# frozen_string_literal: true

module Wahoo
  module Resources
    class User < Base
      def get
        get_one("/v1/user", model: Models::User)
      end

      # update: email, first, last, height, weight, birth, gender
      def update(**attrs)
        put_model("/v1/user", { user: attrs }, model: Models::User)
      end
    end
  end
end
