module Yaoya
  class MyRakuten
    def initialize(config)
      @config = config
      @agent  = Mechanize.new
    end

    def login
      page = @agent.get('https://www.rakuten-sec.co.jp/ITS/V_ACT_Login.html')
      form = page.form_with(:name => 'loginform') do |f|
        f.loginid = @config[:rakuten][:login_id]
        f.passwd  = @config[:rakuten][:login_password]
      end
      @agent.submit(form)
    end

    def get_portfolio
      brands = Array.new

      @agent.page.link_with(:text => ' 国内株式（現物）').click
      page = @agent.page.link_with(:text => 'お気に入り銘柄').click

      rows = page.at('table[@class="tbl-data-01"]').search('tr')

      rows.shift
      rows.each do |row|
        brand = Hash.new

        columns      = row.search('td')
        brand[:code] = columns[1].at('nobr').text.strip
        brand[:name] = columns[2].at('a').text.strip

        brand[:current_price]  = columns[4].at('nobr').text.gsub(/[^\d.]/, "").to_f
        brand[:yday_diff]      = columns[6].at('nobr').text.gsub(/[^\d.\-]/, "").to_f
        brand[:yday_diff_rate] = columns[7].at('nobr').text.gsub(/[^\d.\-]/, "").to_f
        brand[:yday_price]     = brand[:current_price] + brand[:yday_diff]

        brand[:volume]  = columns[8].at('nobr').text.gsub(/[^\d]/, "").to_i

        brands << brand
      end

      brands 
    end
  end
end

