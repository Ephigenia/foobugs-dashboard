#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

# Track public available information of a twitter user like follower, follower
# and tweet count by scraping the user profile page.

# Config
# ------
twitter_username = ENV['TWITTER_USERNAME'] || 'foobugs'

SCHEDULER.every '2m', :first_in => 0 do |job|
  doc = Nokogiri::HTML(open("https://twitter.com/#{twitter_username}"))
  tweets = doc.css('a.js-nav[data-nav=profile] strong').first.attributes['title'].value
  followers = doc.css('a.js-nav[data-nav=followers] strong').first.attributes['title'].value
  following = doc.css('a.js-nav[data-nav=following] strong').first.attributes['title'].value

  send_event('twitter_user_tweets', current: tweets)
  send_event('twitter_user_followers', current: followers)
  send_event('twitter_user_following', current: following)
end
