require 'jpstock'
require 'ansi'
require 'mechanize'

module Yaoya
  class Diff
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))

      tempfile_path = '/tmp/yaoya_diff.json'

      FileUtils.touch(tempfile_path)
      json        = open(tempfile_path) { |io| JSON.load(io) }
      prev_brands = JSON.parse(json, {:symbolize_names => true})

      my_twitter   = MyTwitter.new(@config)
      current_time = Time.now.strftime("%Y/%m/%d %H:%M:%S")

      puts "########################################################"
      puts "# Yahoo (差分情報: #{current_time})"
      puts "########################################################"


      brands      = MyYahoo.new(@config).get_brands
      yday_brands = MyYahoo.new(@config).get_brands( Date.today - 1 )

      puts "".mb_ljust(20) + 
           "現在価格".mb_ljust(12) + 
           "前回比".mb_ljust(24) +
           "前日比"

      brands.each do |b|
        pb =  prev_brands.find { |i| i[:code] == b[:code] }
        yb =  yday_brands.find { |i| i[:code] == b[:code] }
        next if pb.nil?

        p_diff      = b[:current_price] - pb[:current_price]
        p_diff_rate = (( p_diff / pb[:current_price] ) * 100 ).round(2)

        y_diff      = b[:current_price] - yb[:current_price]
        y_diff_rate = (( y_diff / yb[:current_price] ) * 100 ).round(2)

        message = "#{b[:name]}(#{b[:code]}):" + 
                  "#{pb[:current_price]}" + " -> " + "#{b[:current_price]}" +
                  " (+ #{p_diff}円)"

        my_twitter.send_dm("#{current_time} #{message}") if p_diff_rate > 5 && y_diff > 0

        message = "#{b[:name]}(#{b[:code]}):".mb_ljust(20) + 
                  "#{b[:current_price]}".mb_ljust(12) + 
                  disp_profit(p_diff).mb_ljust(18) +
                  "(#{disp_profit(p_diff_rate, "", "%")})".mb_ljust(24) +
                  disp_profit(y_diff).mb_ljust(18) +
                  "(#{disp_profit(y_diff_rate, "", "%")})"

        puts message
      end

      open(tempfile_path, 'w') { |io| JSON.dump(brands.to_json, io) }
    end
  end
end
