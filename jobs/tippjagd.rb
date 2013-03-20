require 'net/http'
require 'json'

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new("tippjagd.de")
  response = http.request(Net::HTTP::Get.new("/api/1/json/stats"))
  if response.code != "200"
    puts "tippjagd api error (status-code: #{response.code})\n#{response.body}"
  else 
    data = JSON.parse(response.body)

    send_event('tippjagd_users', current: data['users'])
    send_event('tippjagd_active_users', current: data['active_users'])
    send_event('tippjagd_guesses', current: data['guesses'])
    send_event('tippjagd_active_guesses', current: data['active_guesses'])
  end
end