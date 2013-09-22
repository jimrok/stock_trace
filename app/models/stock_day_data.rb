class StockDayData < ActiveRecord::Base


  def ema(shift)
    

  end


  def self.fetch_data(stock_code,start_year=nil,end_year=nil,start_month=nil,end_month=nil,start_day=nil,end_day=nil)

    url = ' http://ichart.finance.yahoo.com/table.csv'
    uri = URI.parse(url)
    stock_code = '300072.sz'
    s_code = 300072



    params = { :s => stock_code, :d => end_month,:f=> end_year,:e=>end_day,:a=>start_month,:b=> start_day,:c=> start_year}
    params = params.select {|k,v| !v.nil?}


    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      data_string = res.body
      CSV.parse(data_string,:headers => true) do |row|

        date_string = row[0]
        date_value = date_string[0,4].to_i * 10000 + date_string[5,2].to_i * 100 + date_string[8,2].to_i
        open_value = row[1].to_f
        high_value = row[2].to_f
        low_value = row[3].to_f
        close_value = row[4].to_f
        volume_value = row[5].to_f
        adj_close_value = row[6].to_f

        StockDayData.create(:stock_code=>s_code,:data_time=>date_value,:open=>open_value,:close=>close_value,:high=>high_value,:low=>low_value,:adj_close=>adj_close_value)

 
      end
    else
      puts "data not found."
    end

  end

end
