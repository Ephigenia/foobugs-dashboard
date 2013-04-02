#!/usr/bin/env ruby
require 'net/http'

# Average+Average Voting on an Android App
# 
# This job will track the average vote score and number of votes on an app
# that is registered in the google play market by scraping the google play
# market website.
# 
# There are two variables send to the dashboard:
# `google_play_voters_total` containing the number of people voted
# `google_play_average_rating` float value with the average votes

# Config
# ------
appId = ENV['GOOGLE_PLAY_ID'] || 'com.instagram.android'

SCHEDULER.every '10m', :first_in => 0 do |job|
  
  # prepare request  
  http = Net::HTTP.new("play.google.com", Net::HTTP.https_default_port())
  http.use_ssl = true

  # scrape detail page of app with appId
  response = http.request(Net::HTTP::Get.new("/store/apps/details?id=#{appId}"))
  if response.code != "200"
    puts "google play store website communication (status-code: #{response.code})\n#{response.body}"
  else
    # capture average rating using regexp
    average_rating = /average-rating-value">([\d,.]+)<\/div>/.match(response.body)
    average_rating = average_rating[1].gsub(",", ".").to_f
    send_event('google_play_average_rating', current: average_rating)
    # print "average-rating: #{average_rating}\n"

    # capture
    voters_count = /div class="votes">([\d,.]+)<\/div>/.match(response.body)
    voters_count = voters_count[1].gsub('.', '').to_i
    send_event('google_play_voters_total', current: voters_count)
    # print "google_play_voters_total: #{voters_count}\n"
    
  end
end