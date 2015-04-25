module Yaoya
  class MyYahoo
    def initialize(config)
      @config = config
      @agent  = Mechanize.new
    end

    def get_brands(date = nil)
      brands = Array.new

      brands_config = @config[:brands]
      brands_config.each do |brand|
        if date.nil?
          stock_info = JpStock.price(:code => brand[:code])
        else
          stock_info = JpStock.historical_prices(:code => brand[:code], :start_date => date, :end_date => date).first
        end
        return [] unless stock_info.respond_to?('close')

        brand[:current_price] = stock_info.close
        brand[:profit]        = ( brand[:current_price] - brand[:owned_price] ) * brand[:owned_num] unless brand[:owned_price].nil?
        brand[:profit]        = brand[:profit].round(3) unless brand[:profit].nil?
        brands << brand
      end
      return Marshal.load( Marshal.dump(brands))
    end
  end
end

