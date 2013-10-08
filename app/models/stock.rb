require 'open-uri'
require 'nokogiri'

class Stock < ActiveRecord::Base
  attr_accessible :code, :name, :short_name,:market_code


  before_save do
    self.short_name = PinYin.abbr(self.name)
  end

  def self.sync_all
  	Stock.sync_sh
  	Stock.sync_sz
  end

  def self.sync_sh

    (1..5).each do |pIndex|
    	begin_index = 5*(pIndex -1)

      url = "http://query.sse.com.cn/commonQuery.do?jsonCallBack=jsonpCallback23615&isPagination=true&sqlId=COMMON_SSE_ZQPZ_GPLB_MCJS_SSAG_L&pageHelp.pageSize=50&pageHelp.pageNo=#{begin_index}&pageHelp.beginPage=#{begin_index}&pageHelp.endPage=#{begin_index + 5}&_=1381076506093"
      content = nil
      begin

        open(url,"Referer" => "http://www.sse.com.cn/assortment/stock/list/name/") do |s|
          content = s.read
        end
        nc = content[19,content.length - 20]
        parsed_json = Yajl::Parser.parse(nc)


        doc = Nokogiri::HTML(content)
        nodes = parsed_json["result"]

        nodes.each do |node|
          c_name = node["PRODUCTNAME"]
          c_code = node["PRODUCTID"]
          puts "#{c_code}:#{c_name}"

          stock = Stock.find_by_code(c_code)
          if(stock) then
            stock.update_attributes({:name=>c_name})
            stock.save
          else
            stock = Stock.new({:code=>c_code,:name=>c_name,:market_code=>'ss'})
            stock.save
          end

        end

      rescue => e
        puts e

      end
    end

  end

  def self.sync_sz

    download_url = 'http://www.szse.cn/szseWeb/FrontController.szse?ACTIONID=8&CATALOGID=1110&TABKEY=tab1&ENCODE=1'

    content = nil
    begin
      open(download_url) do |s|
        content = s.read
      end
    rescue => e
      puts e

    end

    doc = Nokogiri::HTML(content)
    nodes = doc.css('tr.cls-data-tr')
    nodes.each do |node|
      c_name = node.children[6].text
      c_code = node.children[0].text
      puts "#{c_code}:#{c_name}"

      stock = Stock.find_by_code(c_code)
      if(stock) then
        stock.update_attributes({:name=>c_name})
        stock.save
      else
        stock = Stock.new({:code=>c_code,:name=>c_name,:market_code=>'sz'})
        stock.save
      end
    end

  end

end
