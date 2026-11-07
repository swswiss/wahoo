# frozen_string_literal: true

require "uri"
require "securerandom"
require "digest"
require "base64"

module Wahoo
  # OAuth 2.0: flux standard + PKCE. Plus deauthorize (revoke).
  module OAuth
    AUTHORIZE_PATH = "/oauth/authorize"
    TOKEN_PATH     = "/oauth/token"

    Tokens = Struct.new(:access_token, :refresh_token, :expires_in, :created_at,
                        keyword_init: true) do
      def expired?
        return false unless created_at && expires_in
        Time.now.to_i >= (created_at.to_i + expires_in.to_i)
      end
    end

    module_function

    def authorize_url(scope:, state: nil, code_challenge: nil, code_challenge_method: nil)
      cfg = require_config!
      params = {
        client_id:     cfg.client_id,
        redirect_uri:  cfg.redirect_uri,
        scope:         scope,
        response_type: "code"
      }
      params[:state] = state if state

      if code_challenge
        params[:code_challenge] = code_challenge
        params[:code_challenge_method] = code_challenge_method || "S256"
      end
      "#{cfg.base_url}#{AUTHORIZE_PATH}?#{URI.encode_www_form(params)}"
    end

    def exchange_code(code, code_verifier: nil)
      cfg = require_config!
      params = {
        grant_type:    "authorization_code",
        code:          code,
        client_id:     cfg.client_id,
        redirect_uri:  cfg.redirect_uri
      }
      # PKCE: fără secret, cu verifier. Standard: cu secret.
      if code_verifier
        params[:code_verifier] = code_verifier
      else
        params[:client_secret] = cfg.client_secret
      end
      post_token(params)
    end

    def refresh(refresh_token, code_verifier: nil)
      cfg = require_config!
      params = {
        grant_type:    "refresh_token",
        refresh_token: refresh_token,
        client_id:     cfg.client_id
      }
      if code_verifier
        params[:code_verifier] = code_verifier
      else
        params[:client_secret] = cfg.client_secret
      end
      post_token(params)
    end

    def generate_code_verifier
      SecureRandom.urlsafe_base64(64).tr("=", "")
    end

    def code_challenge_for(verifier)
      digest = Digest::SHA256.digest(verifier)
      Base64.urlsafe_encode64(digest).tr("=", "")
    end

    def post_token(params)
      cfg = Wahoo.configuration
      resp = Faraday.post("#{cfg.base_url}#{TOKEN_PATH}", params)
      body = resp.body.to_s.empty? ? {} : JSON.parse(resp.body)
      raise Wahoo::Error.from(resp.status, body) unless resp.success?

      Tokens.new(
        access_token:  body["access_token"],
        refresh_token: body["refresh_token"],
        expires_in:    body["expires_in"],
        created_at:    body["created_at"] || Time.now.to_i
      )
    end

    def require_config!
      cfg = Wahoo.configuration
      if cfg.client_id.nil?
        raise Wahoo::ConfigurationError.new("Setează client_id cu Wahoo.configure")
      end
      cfg
    end
  end
end
