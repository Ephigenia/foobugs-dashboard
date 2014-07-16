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
  tweets = doc.css('a[data-nav=tweets]').first.attributes['title'].value.split(' ').first
  followers = doc.css('a[data-nav=followers]').first.attributes['title'].value.split(' ').first
  following = doc.css('a[data-nav=following]').first.attributes['title'].value.split(' ').first

  send_event('twitter_user_tweets', current: tweets)
  send_event('twitter_user_followers', current: followers)
  send_event('twitter_user_following', current: following)
end
