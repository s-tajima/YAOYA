require 'twitter'

module Yaoya
  class MyTwitter
    def initialize(config)
      @config = config
      @client = Twitter::REST::Client.new do |c|
        c.consumer_key        = @config[:twitter][:consumer_key]
        c.consumer_secret     = @config[:twitter][:consumer_secret]
        c.access_token        = @config[:twitter][:access_token]
        c.access_token_secret = @config[:twitter][:access_token_secret]
      end
    end

    def send_dm(message)
      @client.create_direct_message(@config[:twitter][:dm_target], message)
    end
  end
end

