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
      @agent.submit(form).body
    end

    def get_brands
      page = @agent.get('/bsite/member/acc/holdStockList.do')
      table = page.at('//table//table[3]//table[3]//table//table').search('tr')
      brands = Array.new

      iter = table.size / 3
      iter.times do |num|
        brand = Hash.new
        brand[:code], brand[:name] = table.shift.to_s.scan(/<td .*?>(\d+).*<a .*?>(.*)<\/a>.*<\/td>/).flatten
        brand[:owned_num]          = table.first.to_s.scan(/>(\d+)株<\/td>/).flatten[0]
        brand[:current_price]      = table.shift.to_s.scan(/<font .*?>\s*(.*)\s*<\/font>/).flatten[1]
        brand[:profit]             = table.shift.to_s.scan(/<td.*?>(?:<font .*?>)?(.*)\s*(?:<\/font>)?<\/td>/).flatten[3].gsub(/,/,"").to_i || 0
        brands << brand
      end

      brands 
    rescue
      puts "NG"
      puts table.shift.to_s
    end

    def get_portfolio
      page   = @agent.get("https://k.sbisec.co.jp/bsite/member/portfolio/registeredStockList.do")
      tables = page.at('//table//table[5]//table').search('tr')

      brands = Array.new

      tables.each_slice(2) do |header, data|
        brand = Hash.new

        brand[:code], brand[:name] = header.to_s.scan(/<td .*?>(\d+).*<a .*?>(.*)<\/a>.*<\/td>/).flatten

        prices = data.to_s.scan(/<font.*?>(.*)<\/font>/)
        brand[:current_price]  = prices.flatten[1].gsub(/,/,"").to_f || 0.0
        brand[:yday_diff]      = prices.flatten[3].gsub(/,/,"").to_f || 0.0
        brand[:yday_price]     = brand[:current_price] + brand[:yday_diff]
        brand[:yday_diff_rate] = ((brand[:yday_diff] / brand[:yday_price]) * 100 ).round(2)

        brands << brand
      end
      brands 
    end

    def buy_stock(code, quantity, price)
      puts "code:     #{code}"
      puts "quantity: #{quantity}"
      puts "price:    #{price}円"

      return ANSI.red { "Invalid quantity." }        if quantity.to_i % 100 != 0 && quantity.to_i > 10
      return ANSI.red { "Too too expensive price." } if quantity.to_i * price.to_i > 100000

      page = @agent.get("/bsite/member/stock/buyOrderEntry.do?ipm_product_code=#{code}&market=TKY")
      form = page.form do |f|
        f.quantity            = quantity
        f.price               = price
        f.password            = @config[:sbi][:deal_password]
        f.sasinari_kbn        = " "
        f.hitokutei_trade_kbn = 4
        f.radiobutton_with(:value => 'today').check
      end
      page = @agent.submit(form, form.button_with(:value => "確認"))
      sleep 2

      form = page.form
      page = @agent.submit(form, form.button_with(:value => "注文発注"))

      result = page.body.force_encoding('UTF-8').scan(/NISA預りとしてご注文を受付いたしました。/)

      return ANSI.red   { "Order failed."    } if result.empty?
      return ANSI.green { "Order succeeded." }
    end

    def sell_stock(code, quantity, price)
      puts "code:     #{code}"
      puts "quantity: #{quantity}"
      puts "price:    #{price}円"

      page = @agent.get("/bsite/member/stock/sellOrderEntry.do?ipm_product_code=#{code}&hitokutei_kbn=4")
      form = page.form do |f|
        f.quantity            = quantity
        f.price               = price
        f.password            = @config[:sbi][:deal_password]
        f.sasinari_kbn        = " "
        f.hitokutei_trade_kbn = 4
        f.radiobutton_with(:value => 'today').check
      end
      page = @agent.submit(form, form.button_with(:value => "確認"))
      sleep 2

      form = page.form
      page = @agent.submit(form, form.button_with(:value => "注文発注"))

      result = page.body.force_encoding('UTF-8').scan(/NISA預りとしてご注文を受付いたしました。/)

      return ANSI.red   { "Order failed."    } if result.empty?
      return ANSI.green { "Order succeeded." }
    end
  end
end

