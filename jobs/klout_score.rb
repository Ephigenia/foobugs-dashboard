#!/usr/bin/env ruby
require 'net/http'

# Track your public Klout score by scraping the klout score widget’s data using
# a regular expression

# Config
# ------
# you’re username on klout (usually it’s your twitter handle)
klout_username = ENV['KLOUT_USERNAME'] || 'foobugs'

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new("widgets.klout.com")
  response = http.request(Net::HTTP::Get.new("/#{klout_username}"))
  
  if response.code != "200"
    puts "klout communication error (status-code: #{response.code})\n#{response.body}"
  else
    regex = /user-score-flag">\s*([\d]+)/
    result = regex.match(response.body)
    score = result[1]
    if defined?(send_event)
      send_event('klout_score', current: score)
    else
      printf "Klout Score: %d\n", score
    end
  end
end