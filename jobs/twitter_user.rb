#!/usr/bin/env ruby
require 'net/http'

twitter_username = 'foobugs'

SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("twitter.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new("/#{twitter_username}"))
  if response.code != "200"
    puts "twitter communication error (status-code: #{response.code})\n#{response.body}"
  else
    tweets = /profile'>\n<strong>([\d.]+)/.match(response.body)[1].delete('.').to_i
    following = /following'>\n<strong>([\d.]+)/.match(response.body)[1].delete('.').to_i
    followers = /followers'>\n<strong>([\d.]+)/.match(response.body)[1].delete('.').to_i

    send_event('twitter_user_tweets', current: tweets)
    send_event('twitter_user_followers', current: followers)
    send_event('twitter_user_following', current: following)
  end
end