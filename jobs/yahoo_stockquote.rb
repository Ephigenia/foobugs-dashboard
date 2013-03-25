#!/usr/bin/env ruby
require 'net/http'
require 'csv'

# Track the Stock Value of a company by it’s stock quote shortcut using the 
# official yahoo stock quote api
# http://technology.bauzas.com/content-providers/how-to-obtain-stock-quotes-from-yahoo-finance-you-can-query-them-via-excel-too/

# Config
# ------
# configuration
yahoo_stockquote_symbol = 'APPL'
yahoo_stockquote_symbol = 'SIE.HA'

SCHEDULER.every '5s', :first_in => 0 do |job|
  http = Net::HTTP.new("download.finance.yahoo.com")
  response = http.request(Net::HTTP::Get.new("/d/quotes.csv?fb=ac1&s=#{yahoo_stockquote_symbol}"))
  
  if response.code != "200"
    puts "yahoo stock quote communication error (status-code: #{response.code})\n#{response.body}"
  else
    data = CSV.parse(response.body)
    value = data[0][0].to_f
    change = data[0][1].to_f
    last = value + change
      print "value: #{value}   change: #{change}    last: #{last}\n"
      send_event('yahoo_stock_quote', current: value, last: last)
  end
end