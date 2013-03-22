#!/usr/bin/env ruby
require 'net/http'

foursquare_venue_id = 'foobugs/4e9834e1c2ee4857b0660e93'

SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("de.foursquare.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new("/v/#{foursquare_venue_id}"))
  if response.code != "200"
    puts "foursquare communication error (status-code: #{response.code})\n#{response.body}"
  else
    checkins_total = /Check-ins.+insgesamt.+statsnot6digits">([\d.,]+)/
      .match(response.body)[1].delete('.').to_i
    checkins_people = /Besucher.+statsnot6digits">([\d.,]+)/
      .match(response.body)[1].delete('.').to_i
    send_event('foursquare_checkins_total', current: checkins_total)
    send_event('foursquare_checkins_people', current: checkins_people)
  end
end