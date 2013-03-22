#!/usr/bin/env ruby
require 'net/http'
require 'csv'

# Track the Stock Value of a company by it’s stock quote shortcut using the 
# official yahoo stock quote api

# Config
# ------
# configuration
yahoo_stockquote_symbol = 'AAPL'

SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new("download.finance.yahoo.com")
  response = http.request(Net::HTTP::Get.new("/d/quotes.csv?fb=ab&s=#{yahoo_stockquote_symbol}"))
  
  if response.code != "200"
    puts "yahoo stock quote communication error (status-code: #{response.code})\n#{response.body}"
  else
    data = CSV.parse(response.body)
    value = data[0][0].to_f
    send_event('yahoo_stock_quote', current: value)
  end
end