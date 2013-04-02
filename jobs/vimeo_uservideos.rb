#!/usr/bin/env ruby
require 'net/http'
require 'json'

# Job capturing user video info
# 
# This job will capture the data from all videos of a user using the vimeo
# api: https://developer.vimeo.com/apis/simple#user-request
# This can be then be used to display a top-5 in a "List" widget
# 
# This job will send three lists containing likes, plays and comments counts:
# `vimeo_uservideos_likes`, `vimeo_uservideos_plays` and
# `vimeo_uservideos_comments`
# 
# There’s also a `vimeo_uservideos_

# Config
# ------
vimeo_username = 'spread'
# set the number of videos to display
vimeo_max_length = 5
# set to false if videos should not be ordered by value
vimeo_ordered = true

SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("vimeo.com")
  response = http.request(Net::HTTP::Get.new("/api/v2/#{vimeo_username}/videos.json"))
  
  if response.code != "200"
    puts "vimeo api error (status-code: #{response.code})\n#{response.body}"
  else
    videosData = JSON.parse(response.body)

    videos_likes = Array.new
    videos_plays = Array.new
    videos_comments = Array.new
    videos_sums = Array.new

    # generate lists
    videosData.each do |video|
      title = video['title']
      if title.length > 12
        title = title[0..10] + ".."
      end
      videos_likes.push({
        label: title,
        value: video['stats_number_of_likes']
      })
      videos_plays.push({
        label: title,
        value: video['stats_number_of_plays']
      })
      videos_comments.push({
        label: title,
        value: video['stats_number_of_comments']
      })
      videos_sums.push({
        label: title,
        value: (
          video['stats_number_of_plays'] +
          10 * video['stats_number_of_likes'] +
          50 * video['stats_number_of_comments']
        )
      })
    end

    # order lists by values?
    if vimeo_ordered
      videos_likes = videos_likes.sort_by { |obj| -obj[:value] }
      videos_plays = videos_plays.sort_by { |obj| -obj[:value] }
      videos_comments = videos_comments.sort_by { |obj| -obj[:value] }
      videos_sums = videos_sums.sort_by { |obj| -obj[:value] }
    end

    send_event('vimeo_uservideos_likes', { items: videos_likes.slice(0, vimeo_max_length) })
    send_event('vimeo_uservideos_plays', { items: videos_plays.slice(0, vimeo_max_length) })
    send_event('vimeo_uservideos_comments', { items: videos_comments.slice(0, vimeo_max_length) })
    send_event('vimeo_uservideos_sums', { items: videos_sums.slice(0, vimeo_max_length) })
    
  end
end