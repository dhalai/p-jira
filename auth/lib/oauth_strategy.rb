require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PJira < OmniAuth::Strategies::OAuth2
      option :name, :p_jira

      option :client_options, {
        site: "http://localhost:3000/oauth/authorize",
        authorize_url: "http://localhost:3000/oauth/authorize"
      }

      uid { raw_info["public_id"] }

      info do
        {
          email: raw_info['email'],
          public_id: raw_info['public_id'],
          full_name: raw_info['full_name'],
          phone_number: raw_info['phone_number'],
          slack_account: raw_info['slack_account'],
          active: raw_info['active'],
          role: raw_info['role']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/accounts/current').parsed
      end
    end
  end
end
