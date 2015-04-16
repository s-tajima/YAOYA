module Yaoya
  class MySBI
    def initialize(config)
      @config = config
      @agent  = Mechanize.new
    end

    def login
      page = @agent.get('https://k.sbisec.co.jp/bsite/visitor/top.do')
      form = page.form_with(:name => 'form1') do |f|
        f.username = @config[:sbi][:username]
        f.password = @config[:sbi][:login_password]
      end
      @agent.submit(form)
    end

    def get_brands
      table = @agent.get('/bsite/member/acc/holdStockList.do').at('//table//table[3]//table[3]//table//table').search('tr')
      brands = Array.new

      iter = table.size / 3
      iter.times do |num|
        brand = Hash.new
        brand[:code], brand[:name], brand[:market] = table.shift.to_s.scan(/<td .*>(\d+).*<a .*>(.*)<\/a>(.*)<\/td>/).flatten
        brand[:owned_num]                          = table.first.to_s.scan(/>(\d+)株<\/td>/).flatten[0]
        brand[:current_price]                      = table.shift.to_s.scan(/<font .*>\s*(.*)\s*<\/font>/).flatten[1]
        brand[:profit]                             = table.shift.to_s.scan(/<font .*>(.*)\s*<\/font>/).flatten[3].gsub(/,/,"").to_i || 0
        brand[:profit]
        brands << brand
      end

      brands 
    end

    def buy_stock
      page = @agent.get('/bsite/member/stock/buyOrderEntry.do?ipm_product_code=1570&market=SOR')
      page.form do |f|
      end
    end
  end
end

