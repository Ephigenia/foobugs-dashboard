#!/usr/bin/env ruby
require 'net/http'
require 'json'

# This job can track some metrics of a single youtube video by accessing the
# public available api of youtube.

# Config
# ------
# The youtube video id. Get this from the `v` parameter of the video’s url
youtube_video_id = ENV['YOUTUBE_VIDEO_ID'] || 'cnc6yyxpdfg'

SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new("gdata.youtube.com")
  response = http.request(Net::HTTP::Get.new("/feeds/api/videos?q=#{youtube_video_id}&v=2&alt=jsonc"))
  
  if response.code != "200"
    puts "youtube api error (status-code: #{response.code})\n#{response.body}"
  else
    videos = JSON.parse(response.body)['data']['items']
    
    if defined?(send_event)
      send_event('youtube_video_rating', current: videos[0]['ratingCount'])
      send_event('youtube_video_views', current: videos[0]['viewCount'])
      send_event('youtube_video_likes', current: videos[0]['likeCount'])
      send_event('youtube_video_comments', current: videos[0]['commentCount'])
      send_event('youtube_video_favorites', current: videos[0]['favoriteCount'])
    else
      print videos[0]
    end
  end
end