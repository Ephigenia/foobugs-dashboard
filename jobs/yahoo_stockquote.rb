#!/usr/bin/env ruby
require 'net/http'
require 'csv'

# Track the Stock Value of a company by it’s stock quote shortcut using the 
# official yahoo stock quote api
# 
# This will record all current values and changes to all stock indizes you
# indicate in the `yahoo_stockquote_symbols` array. Each value is then available
# in the `yahoo_stock_quote_[symbol_slug]` variables and combined in a list
# `yahoo_stock_quote_list` which contains them all.

# Config
# ------
# Symbols of all indizes you want to track
yahoo_stockquote_symbols = [
  'AAPL',      # will become `yahoo_stock_quote_appl`
  'GOOG',      
  'YHOO',      
  'FB',        
  'ZNGA',
  'EBAY',
  'AMZN',
  'MSFT',
  'ORCL',
  'DELL',
  'CSCO',
  'QCOM',
  'SIE.HA'     # will become `yahoo_stock_quote_sie_ha`
]

SCHEDULER.every '30s', :first_in => 0 do |job|
  
  s = yahoo_stockquote_symbols.join(',').upcase
  http = Net::HTTP.new("download.finance.yahoo.com")
  response = http.request(Net::HTTP::Get.new("/d/quotes.csv?fb=nsac1&s=#{s}"))
  
  if response.code != "200"
    puts "yahoo stock quote communication error (status-code: #{response.code})\n#{response.body}"
  else
    # read data from csv
    data = CSV.parse(response.body)

    stocklist = Array.new

    # iterate over different stock symbols and create
    # the list and single values to be pushed to the frontend
    data.each do |line|
      name = line[0]
      symbol = line[1]
      current = line[2].to_f
      change = line[3].to_f

      # add data to list
      stocklist.push({
        label: name,
        value: current.round(2)
      })

      # send single value and change to dashboard
      widgetVarname = "yahoo_stock_quote_" + symbol.gsub(/[^A-Za-z0-9]+/, '_').downcase
      widgetData = {
        current: current
      }
      if change != 0.0
        widgetData[:last] = current + change
      end
      if defined?(job)
        send_event(widgetVarname, widgetData)
      else
        print "current: #{symbol} #{current} #{change} #{widgetVarname}\n"
      end
    end

    # send list to dashboard
    if defined?(job)
      send_event('yahoo_stock_quote_list', { items: stocklist })
    else
      print stocklist
    end
 
  end
end