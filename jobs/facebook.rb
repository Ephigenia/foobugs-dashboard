#!/usr/bin/env ruby
require 'net/http'
require 'json'

# this job will track some metrics of a facebook page

# Config
# ------
# the fb id or username of the page you’re planning to track
facebook_graph_username = ENV['FACEBOOK_GRAPH_USERNAME'] || 'foobugs'

SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new("graph.facebook.com")
  response = http.request(Net::HTTP::Get.new("/#{facebook_graph_username}"))
  if response.code != "200"
    puts "facebook graph api error (status-code: #{response.code})\n#{response.body}"
  else 
    data = JSON.parse(response.body)
    if data['likes']
      send_event('facebook_likes', current: data['likes'])
      send_event('facebook_checkins', current: data['checkins'])
      send_event('facebook_were_here_count', current: data['were_here_count'])
      send_event('facebook_talking_about_count', current: data['talking_about_count'])
    end
  end
end
