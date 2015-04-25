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

      puts "########################################################"
      puts "# SBI (#{current_time})"
      puts "########################################################"
      puts "".mb_ljust(28) + "現在価格".mb_ljust(12) + "TOTAL収支"

      my_sbi = MySBI.new(@config)
      my_sbi.login
      my_sbi.get_brands.each do |b|
        puts "#{b[:name]}(#{b[:code]}):".mb_ljust(28) + "#{b[:current_price]}".ljust(12) + "#{disp_profit(b[:profit])}" 
      end
    end
  end
end
