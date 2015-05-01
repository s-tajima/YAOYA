require 'big_query'

module Yaoya
  class Record
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))

      date = Date.today.strftime("%Y%m%d")
      time = Time.now
      table_name = 'stock_data_' + date

      my_google = MyGoogle.new(@config)
      my_google.create_table(table_name)

      my_sbi = MySBI.new(@config)
      my_sbi.login
      brands = my_sbi.get_portfolio

      my_google.insert(table_name, time, brands)  
    end
  end
end
