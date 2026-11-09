# frozen_string_literal: true

module Wahoo
  class Client
    attr_reader :access_token

    def initialize(access_token:, max_retries: nil, retry_backoff: nil)
      raise ArgumentError, "access_token lipsește" if access_token.nil?
      @access_token = access_token
      @connection = Connection.new(access_token: access_token,
                                   max_retries: max_retries, retry_backoff: retry_backoff)
    end

    def user;        @user        ||= Resources::User.new(@connection); end
    def workouts;    @workouts    ||= Resources::Workouts.new(@connection); end
    def routes;      @routes      ||= Resources::Routes.new(@connection); end
    def plans;       @plans       ||= Resources::Plans.new(@connection); end
    def power_zones; @power_zones ||= Resources::PowerZones.new(@connection); end
    def uploads;     @uploads     ||= Resources::Uploads.new(@connection); end
    def permissions; @permissions ||= Resources::Permissions.new(@connection); end

    # revocă accesul (shortcut)
    def deauthorize
      permissions.revoke
    end
  end
end
