#!/usr/bin/env ruby
require 'net/http'
require 'openssl'

# Track public available information of a twitter user like follower, follower
# and tweet count by scraping the user profile page.

# Config
# ------
twitter_username = ENV['TWITTER_USERNAME'] || 'foobugs'

SCHEDULER.every '2m', :first_in => 0 do |job|
  http = Net::HTTP.new("twitter.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # disable ssl certificate check
  response = http.request(Net::HTTP::Get.new("/#{twitter_username}"))
  if response.code != "200"
    puts "twitter communication error (status-code: #{response.code})\n#{response.body}"
  else

    tweets = /tweet_stats\".+<strong>([\d.]+)<\/strong>/.match(response.body)[1].delete('.,').to_i
    following = /<strong>([\d.]+)<\/strong> folgt/.match(response.body)[1].delete('.,').to_i
    followers = /<strong>([\d.]+)<\/strong> Follower/.match(response.body)[1].delete('.,').to_i

    send_event('twitter_user_tweets', current: tweets)
    send_event('twitter_user_followers', current: followers)
    send_event('twitter_user_following', current: following)
  end
end