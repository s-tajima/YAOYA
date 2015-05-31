require 'redis'

module Yaoya
  class MyRedis
    def initialize(config)
      @config = config

      host = @config[:redis][:host]
      port = @config[:redis][:port]
      db   = @config[:redis][:db]
      
      @redis = Redis.new(:host => host, :port => port, :db => db)
    end

    def hset(key, field, value)
      @redis.hset(key, field, value)
    end

    def hsetnx(key, field, value)
      @redis.hsetnx(key, field, value)
    end

    def hgetall(key)
      @redis.hgetall(key)
    end

    def keys(key)
      @redis.keys(key)
    end

  end
end

