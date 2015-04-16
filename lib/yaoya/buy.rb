require 'jpstock'
require 'ansi'
require 'mechanize'

module Yaoya
  class Buy
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))

      my_sbi = MySBI.new(@config)
      my_sbi.login
      my_sbi.buy_stock

    end
  end
end
