#!/usr/bin/env ruby
require 'net/http'

# Slideshare User Info
# 
# This job scrapes two numbers from a slideshare user account:
# `slideshare_user_slides_count`: Number of slideshare presentations shared
# `slideshare_user_followers_count`: Number of followers of the account

# Config
# ------
# user name of the slideshare account
slideshare_username = ENV['SLIDESHARE_USERNAME'] || 'ephigenia1'

SCHEDULER.every '2m', :first_in => 0 do |job|
  http = Net::HTTP.new("www.slideshare.net")
  response = http.request(Net::HTTP::Get.new("/#{slideshare_username}"))

  # check response code
  if response.code != "200"
    puts "slideshare communication error (status-code: #{response.code})\n#{response.body}"
  else
    # capture slideshare user followers count using regexp on the source
    slideshare_user_followers_count = /(\d+) Follower/.match(response.body)
    slideshare_user_followers_count = slideshare_user_followers_count[1].to_i
    if defined?(send_event)
      send_event('slideshare_user_followers_count', current: slideshare_user_followers_count)
    else
      print "slideshare followers: #{slideshare_user_followers_count}\n"
    end

    # capture slideshare slides count using regexp on the source
    slideshare_user_slides_count = /(\d+) SlideShares/.match(response.body)
    slideshare_user_slides_count = slideshare_user_slides_count[1].to_i
    if defined?(send_event)
      send_event('slideshare_user_slides_count', current: slideshare_user_slides_count)
    else
      print "slideshare followers: #{slideshare_user_slides_count}\n"
    end
  end
end