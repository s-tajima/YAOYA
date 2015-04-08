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

    def parse
      @opt_parser.parse!(@args)
    end

    def val(index)
      @options[index]
    end
  end
end


