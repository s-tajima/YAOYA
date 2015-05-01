require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

module Yaoya
  class MyGoogle
    def initialize(config)
      @config = config

      opts = Hash.new
      opts['client_id']     = @config[:google][:client_id]
      opts['service_email'] = @config[:google][:service_email]
      opts['key']           = @config[:google][:key_file]
      opts['project_id']    = @config[:google][:project_id]
      opts['dataset']       = @config[:google][:dataset]
      
      @bq = BigQuery::Client.new(opts)
    end

    def create_table(table_name)
      table_schema = { 
        :time  => { :type => 'TIMESTAMP' },
        :code  => { :type => 'STRING'    },
        :price => { :type => 'FLOAT'     }
      }

      return false if table_exists?(table_name)

      @bq.create_table(table_name, table_schema)
    end

    def table_exists?(table_name)
      @bq.table_data(table_name)
      return true
    rescue
      return false 
    end

    def insert(table_name, time, brands)
      time = time.utc.strftime("%Y-%m-%d %H:%M:%S")

      data = Array.new
      brands.each do |b|
        row = Hash.new
        row[:code]  = b[:code]
        row[:price] = b[:current_price]
        row[:time]  = time
        data << row
      end

      result = @bq.insert(table_name, data)
    end

  end
end

