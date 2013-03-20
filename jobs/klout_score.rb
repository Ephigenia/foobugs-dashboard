require 'net/http'

# configuration
twitter_username = 'foobugs'

SCHEDULER.every '30m', :first_in => 0 do |job|
  http = Net::HTTP.new("widgets.klout.com")
  response = http.request(Net::HTTP::Get.new("/#{twitter_username}"))
  
  if response.code != "200"
    puts "klout communication error (status-code: #{response.code})\n#{response.body}"
  else
    regex = /class="kscore\s*" title="(\d+)"/
    result = regex.match(response.body)
    score = result[1]
    send_event('klout_score', current: score)
  end
end

