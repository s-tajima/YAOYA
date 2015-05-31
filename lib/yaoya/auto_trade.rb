module Yaoya
  class AutoTrade
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))

      my_redis  = MyRedis.new(@config)
      my_logger = MyLogger.new(@config, 'auto_trade.log')

      loop do 
        keys = my_redis.keys('buy-request.*')
        keys.each do |key|
          request = my_redis.hgetall(key)

          unless request['order'].nil? 
            next
          end

          my_logger.info("#{key} done. price: #{request['price']}, quantity: #{request['quantity']}")
          my_redis.hset(key, 'order', 'done')
        end

        sleep 1
      end
    end
  end
end
