require 'jpstock'
require 'ansi'
require 'mechanize'

module Yaoya
  class Check
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))
      current_time = Time.now.strftime("%Y/%m/%d %H:%M:%S")

      #puts "########################################################"
      #puts "# Yahoo"
      #puts "########################################################"
      #get_brands_by_yahoo.each do |b|
      #  puts "#{b[:name]}(#{b[:code]}):".mb_ljust(20) + "#{b[:current_price]}".ljust(10) + "(#{disp_profit(b[:profit])})" 
      #end

      puts "########################################################"
      puts "# SBI (#{current_time})"
      puts "########################################################"
      puts "".mb_ljust(20) + "現在価格".mb_ljust(12) + "TOTAL収支"
      get_brands_by_sbi.each do |b|
        puts "#{b[:name]}(#{b[:code]}):".mb_ljust(20) + "#{b[:current_price]}".ljust(12) + "#{disp_profit(b[:profit])}" 
      end
    end

    def get_brands_by_yahoo
      my_yahoo = MyYahoo.new(@config)
      my_yahoo.get_brands
    end

    def get_brands_by_sbi
      my_sbi = MySBI.new(@config)
      my_sbi.login
      my_sbi.get_brands
    end
  end
end
