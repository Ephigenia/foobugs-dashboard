#!/usr/bin/env ruby
require 'net/http'

# Track Instagram User Data
# 
# This job will track public info about public instagram profiles scraping
# the public available user page.
# 
# Variables: 
# `instagram_user_photos` count of photos
# `instagram_user_following` users the account is following
# `instagram_user_followers` users following the user

# Config
# ------
# instagram user name
instagram_username = ENV['INSTAGRAM_USERNAME'] || 'nike'

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new("instagram.com")
  response = http.request(Net::HTTP::Get.new("/#{instagram_username}"))
  
  if response.code != "200"
    puts "instagram communication error (status-code: #{response.code})\n#{response.body}"
  else
    
    match = /"counts":{"media":(\d+),"followed_by":(\d+),"follows":(\d+)}/.match(response.body)
    
    # collect all the info in a list
    userInfo = [
      {
        label: 'Followers',
        value: match[2].to_i
      },
      {
        label: 'Following',
        value: match[3].to_i
      },
      {
        label: 'Photos',
        value: match[1].to_i
      }
    ]
    # send the list
    # print userInfo
    send_event('instagram_userinfo', {items: userInfo})

    # send every list item as a single event
    userInfo.each do |element|
      varname = "instagram_user_" + element[:label].downcase
      # print "#{varname}: #{element[:value]}\n"
      send_event(varname, current: element[:value])
    end

  end
end