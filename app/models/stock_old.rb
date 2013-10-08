
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'open-uri'         
require 'rubygems'
require 'activerecord'
require 'activesupport'
require 'nokogiri'


ActiveRecord::Base.establish_connection(:adapter => 'mysql',:host => "192.168.1.5",   
  :username => "root",   
  :password => "xpdb2011",   
  :database => "xpdb",
  :encoding => "utf8")



class Stock < ActiveRecord::Base
end

def download_ss
  (1..19).each { |pIndex|  
    url = 'http://www.sse.com.cn/sseportal/webapp/datapresent/SSEQueryStockInfoAct?keyword=&reportName=BizCompStockInfoRpt&PRODUCTID=&PRODUCTJP=&PRODUCTNAME=&CURSOR=' + pIndex.to_s
    content = nil
    begin
      open(url) do |s|       
        content = s.read
      end
      
      doc = Nokogiri::HTML(content)
      nodes = doc.css("td.table3 > a")
      nodes.each {|node|
        c_name = node.parent.parent.children[2].text
        c_code = node.text
        puts "#{c_code}:#{c_name}"
        
        stock = Stock.find_by_code(c_code)
        if(stock) then
          stock.update_attributes({:short_name=>c_name})
          stock.save
        else
          stock = Stock.new({:code=>c_code,:short_name=>c_name,:market_code=>'ss'})
          stock.save
        end
        
      }
        
    rescue => e
      puts e
        
    end
  }
  
end


def download_sz
  
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
  nodes.each {|node|
    c_name = node.children[6].text
    c_code = node.children[0].text
    puts "#{c_code}:#{c_name}"
        
    stock = Stock.find_by_code(c_code)
    if(stock) then
      stock.update_attributes({:short_name=>c_name})
      stock.save
    else
      stock = Stock.new({:code=>c_code,:short_name=>c_name,:market_code=>'sz'})
      stock.save
    end
  }
  
  
end

def update_pinyin
  
  require 'pinyin'
  py = PinYin.instance
  
  stocks = Stock.find(:all)
  stocks.each { |stock|  
    hz = stock.short_name
    py_code = py.to_pinyin_abbr(hz)
    stock.update_attributes({:py_code=>py_code})
    stock.save
  }
  
end

update_pinyin()

#download_ss()