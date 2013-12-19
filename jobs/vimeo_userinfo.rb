#!/usr/bin/env ruby
require 'net/http'
require 'json'

# Job capturing user info from vimeo
# 
# This job will use the vimeo api to get informations about a vimeo user. 
# The captured info are either send as a list `viemo_userinfo_list` with labels
# and values which can be used in the "List" widget or single values
# `vimeo_userinfo_[varname]` which can be displayed using the "Number" widget.

# Config
# ------
vimeo_username = 'spread'

SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("vimeo.com")
  response = http.request(Net::HTTP::Get.new("/api/v2/#{vimeo_username}/info.json"))
  
  if response.code != "200"
    puts "vimeo api error (status-code: #{response.code})\n#{response.body}"
  else
    data = JSON.parse(response.body)

    # collect data for the list widget
    items = [
      {
        label: 'Uploads',
        value: data['total_videos_uploaded']
      },
      {
        label: 'Likes',
        value: data['total_videos_liked']
      },
      {
        label: 'Contacts',
        value: data['total_contacts'],
      },
      {
        label: 'Albums',
        value: data['total_albums'],
      },
      {
        label: 'Channels',
        value: data['total_channels'],
      }
    ]

    # send list
    if defined?(send_evnt)
      send_event('vimeo_userinfo_list', { items: items })
    else
      print items
    end
    
    # send single values (for Number widget)
    items.each do |item|
      varname = "vimeo_userinfo_" + item[:label].downcase
      if defined?(send_event)
        send_event(varname, current: item[:value])
      else
        print "#{varname}: #{item[:value]}\n"
      end
    end
    
  end
end