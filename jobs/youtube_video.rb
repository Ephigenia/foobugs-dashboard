require 'net/http'
require 'json'

# configuration
youtube_video_id = '91HTjK8TTJY'

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new("gdata.youtube.com")
  response = http.request(Net::HTTP::Get.new("/feeds/api/videos?q=#{youtube_video_id}&v=2&alt=jsonc"))
  
  if response.code != "200"
    puts "youtube api error (status-code: #{response.code})\n#{response.body}"
  else
  	videos = JSON.parse(response.body)['data']['items']
  	
  	send_event('youtube_video_rating', current: videos[0]['ratingCount'])
  	send_event('youtube_video_views', current: videos[0]['viewCount'])
  	send_event('youtube_video_likes', current: videos[0]['likeCount'])
  	send_event('youtube_video_comments', current: videos[0]['commentCount'])
  	send_event('youtube_video_favorites', current: videos[0]['favoriteCount'])
    
  end
end