require 'jpstock'
require 'ansi'
require 'mechanize'

module Yaoya
  class Sell
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.add_option_code
      options.add_option_p
      options.add_option_q
      options.parse

      @config  = load_config(options.val(:config_path))

      code     = options.val(:code)
      quantity = options.val(:quantity)
      price    = options.val(:price)

      my_sbi = MySBI.new(@config)
      my_sbi.login

      puts my_sbi.sell_stock(code, quantity, price)
    end
  end
end
