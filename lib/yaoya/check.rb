require 'jpstock'
require 'ansi'

module Yaoya
  class Check
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      $config  = load_config(options.val(:config_path))

      brands = get_brands_by_yaml

      brands.each do |brand|
        stock_info = JpStock.price(:code => brand[:code])
        diff = diff_disp(stock_info.close - brand[:price]) unless brand[:price].nil?
        puts "Code #{brand[:code]}: @#{stock_info.close} (#{diff})"
      end
    end

    def get_brands_by_yaml
      $config[:brands]
    end

    def get_brands_by_sbi
      $config[:brands]
    end

    def diff_disp(diff)
      return ANSI.green{ "+ #{diff.round(3)}" }     if diff > 0
      return ANSI.red  { "- #{diff.abs.round(3)}" } if diff < 0
      return 0
    end
  end
end
