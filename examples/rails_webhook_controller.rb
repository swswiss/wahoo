# frozen_string_literal: true

class WahooWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = Wahoo::Webhooks::Handler.verify_token!(request.raw_post)

    if event.workout_summary?
      user = User.find_by(wahoo_user_id: event.user_id)   # event.user.id
      if user
        s = event.workout_summary
        Rails.logger.info("User #{user.id}: tură #{s.distance_km} km, #{s.duration_human}")
        # ...
      end
    end

    head :ok
  rescue Wahoo::Unauthorized
    head :unauthorized
  end
end
