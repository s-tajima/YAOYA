module Yaoya
  class MyLogger
    def initialize(config, log_name = nil)
      @config = config

      log_path = STDOUT

      unless log_name.nil?
        log_path = @config[:log][:prefix] + "/" + log_name 
      end

      @logger = Logger.new(log_path)
    end

    def info(message)
      @logger.info(message) 
    end
  end
end

