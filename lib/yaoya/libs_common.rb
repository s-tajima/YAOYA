require 'yaml'
require 'pp'
require 'optparse'

module Yaoya
  def load_config(config_file)
    config_file = "#{$BASE_DIR}config/default.yml" if config_file.nil?
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
end
