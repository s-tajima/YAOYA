module Yaoya
  class Watch
    RATE_CRITERIA = 3

    def initialize(args)
      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))

      tempfile_path = '/tmp/yaoya_watch.json'

      FileUtils.touch(tempfile_path)
      json        = open(tempfile_path) { |io| JSON.load(io) }
      prev_brands = JSON.parse(json, {:symbolize_names => true})

      my_twitter   = MyTwitter.new(@config)
      current_time = Time.now.strftime("%Y/%m/%d %H:%M:%S")

      puts "########################################################"
      puts "# Rakuten (差分情報: #{current_time})"
      puts "########################################################"

      my_rakuten = MyRakuten.new(@config)
      my_rakuten.login

      brands = my_rakuten.get_portfolio

      puts "".mb_ljust(30) +
           "現在価格".mb_ljust(12) +
           "前回比".mb_ljust(24) +
           "前日比".mb_ljust(24) +
           "出来高"

      brands.each do |b|
        pb =  prev_brands.find { |i| i[:code] == b[:code] }
        next if pb.nil?

        p_diff      = b[:current_price] - pb[:current_price]
        p_diff_rate = (( p_diff / pb[:current_price] ) * 100 ).round(2)

        message = "#{b[:name]}(#{b[:code]}):" +
                  "#{pb[:current_price]}" + " -> " + "#{b[:current_price]}" +
                  " (+ #{p_diff}円)"

        if p_diff_rate > RATE_CRITERIA
          my_twitter.send_dm("#{current_time} #{message}") 

          order_price = b[:current_price] + b[:current_price] * (RATE_CRITERIA.to_f / 100)
          order_price = order_price.round

          my_redis = MyRedis.new(@config)
          my_redis.hsetnx("buy-request.#{b[:code]}", 'price', order_price)
          my_redis.hsetnx("buy-request.#{b[:code]}", 'quantity', 100)
          my_redis.hgetall("buy-request.#{b[:code]}")
        end

        message = "#{b[:name]}(#{b[:code]}):".mb_ljust(30) +
                  "#{b[:current_price]}".mb_ljust(12) +
                  disp_profit(p_diff).mb_ljust(18) +
                  "(#{disp_profit(p_diff_rate, "", "%")})".mb_ljust(24) +
                  disp_profit(b[:yday_diff]).mb_ljust(18) +
                  "(#{disp_profit(b[:yday_diff_rate], "", "%")})".mb_ljust(24) +
                  "#{b[:volume]}"

        puts message
      end

      open(tempfile_path, 'w') { |io| JSON.dump(brands.to_json, io) }
    end
  end
end
