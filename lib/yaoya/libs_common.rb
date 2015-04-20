require 'yaml'
require 'pp'
require 'optparse'

module Yaoya
  def load_config(config_file)
    config_file = "#{$BASE_DIR}configs/default.yml" if config_file.nil?
    YAML.load(File.open(config_file))
  end

  def confirm(message)
    loop do
      print "[#{$config[:env]}] #{message} (y/n): "
      input = gets.chomp
      if input == "y"
        break
      end

      if input == "n"
        puts "Canceled."
        exit 0
      end
    end
  end

  def disp_profit(profit, prefix = '', suffix = '')
    return ""                                       if profit.nil?
    return ANSI.green { "+ #{prefix}#{profit.round(3)}#{suffix}" }     if profit > 0
    return ANSI.red   { "- #{prefix}#{profit.abs.round(3)}#{suffix}" } if profit < 0
    return ANSI.white { 0 }
  end
end

class String
  def mb_ljust(width, padding=' ')
    output_width = each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end
 
end

