module Yaoya
  class MyOptionParser
    def initialize(args)
      @args       = args
      @options    = Hash.new
      @opt_parser = OptionParser.new
    end

    def add_option_c
      @opt_parser.on('-c val', '--config-file=val', 'Config file.') do |v| 
        @options[:config_path] = v 
      end
    end

    def add_option_code
      @opt_parser.on('-C val', '--code=val', 'stock code.') do |v| 
        @options[:code] = v 
      end
    end

    def add_option_q
      @opt_parser.on('-q val', '--quantity=val', 'quantity.') do |v| 
        @options[:quantity] = v 
      end
    end

    def add_option_p
      @opt_parser.on('-p val', '--price=val', 'price.') do |v| 
        @options[:price] = v 
      end
    end


    def parse
      @opt_parser.parse!(@args)
    end

    def val(index)
      @options[index]
    end
  end
end


