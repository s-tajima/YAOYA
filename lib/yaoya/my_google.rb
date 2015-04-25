require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

module Yaoya
  class MyGoogle
    def initialize(config)
      @config = config
      @agent  = Mechanize.new
        
      client = Google::APIClient.new(
        :application_name => 'Example Ruby Bigquery',
        :application_version => '1.0.0'
      )

      client.authorization.client_id     = oauth_yaml["client_id"]
      client.authorization.client_secret = oauth_yaml["client_secret"]
      client.authorization.scope         = oauth_yaml["scope"]
      client.authorization.refresh_token = oauth_yaml["refresh_token"]
      client.authorization.access_token  = oauth_yaml["access_token"]

      # Initialize Bigquery client.
      bq_client = client.discovered_api('bigquery', 'v2')

        
        plus = client.discovered_api('plus')
        
        client_secrets = Google::APIClient::ClientSecrets.load
        
        flow = Google::APIClient::InstalledAppFlow.new(
          :client_id => client_secrets.client_id,
          :client_secret => client_secrets.client_secret,
          :scope => ['https://www.googleapis.com/auth/plus.me']
        )
        client.authorization = flow.authorize
        
        result = client.execute(
          :api_method => plus.activities.list,
          :parameters => {'collection' => 'public', 'userId' => 'me'}
        )
        
        puts result.data
    end
  end
end

