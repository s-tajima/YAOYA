module Yaoya
  class Load
    def initialize(args)

      options = MyOptionParser.new(args)
      options.add_option_c
      options.parse

      @config  = load_config(options.val(:config_path))
      current_time = Time.now.strftime("%Y/%m/%d %H:%M:%S")

      code = 1570
      date = '2015-04-28'

      @agent = Mechanize.new
      csv = @agent.get("http://k-db.com/stocks/#{code}-T/minutely?date=#{date}&download=csv").body

      CSV.parse(csv) do |row|
        datetime = "#{row[0]} #{row[1]}"
        open     = row[2]
        high     = row[3]
        low      = row[4]
        close    = row[4]
        volume   = row[5]
        sales    = row[6]
      end
    end
  end
end
