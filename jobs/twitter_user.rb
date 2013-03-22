#!/usr/bin/env ruby
require 'net/http'

# Track public available information of a twitter user like follower, follower
# and tweet count by scraping the user profile page.

# Config
# ------
twitter_username = 'foobugs'

SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("twitter.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new("/#{twitter_username}"))
  if response.code != "200"
    puts "twitter communication error (status-code: #{response.code})\n#{response.body}"
  else

    statsRegexp = /statnum">([\d.,]+)/
    matches = response.body.scan(statsRegexp)
    print matches
    if matches.length == 3
      tweets = matches[0][0].delete('.').to_i
      following = matches[1][0].delete('.').to_i
      followers = matches[2][0].delete('.').to_i
    else
      tweets = /profile'>\n<strong>([\d.]+)/.match(response.body)[1].delete('.').to_i
      following = /following'>\n<strong>([\d.]+)/.match(response.body)[1].delete('.').to_i
      followers = /followers'>\n<strong>([\d.]+)/.match(response.body)[1].delete('.').to_i
    end

    send_event('twitter_user_tweets', current: tweets)
    send_event('twitter_user_followers', current: followers)
    send_event('twitter_user_following', current: following)
  end
end