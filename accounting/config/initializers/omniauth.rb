Rails.application.config.middleware.use OmniAuth::Builder do
  provider :p_jira, ENV['OAUTH_UID'], ENV['OAUTH_Secret'], scope: 'public write'
end
