#!/usr/bin/env ruby
require 'net/http'

# this job can track the total number of checkins and count of persons that
# checked in in a foursquare venue without using the foursquare api.

# Config
# ------
# the id of the venue you want to track, get it by navigating to the venue’s
# detail page and paste the part of the url after the "/v/"
foursquare_venue_id = ENV['FOURSQUARE_VENUE_ID'] || 'foobugs/4e9834e1c2ee4857b0660e93'

SCHEDULER.every '30s', :first_in => 0 do |job|
  http = Net::HTTP.new("de.foursquare.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new("/v/#{foursquare_venue_id}"))
  if response.code != "200"
    puts "foursquare communication error (status-code: #{response.code})\n#{response.body}"
  else
    # get the numbers by regexp them out of the html source
    checkins_total = /Insgesamte Check-Ins.+venueStatCount.+data-count="([\d.,]+)/
      .match(response.body)[1].delete('.').to_i
    checkins_people = /rightColumn.+Total Visitors.+venueStatCount.+data-count="([\d.,]+)">.+venueStatCount/
      .match(response.body)[1].delete('.').to_i
    send_event('foursquare_checkins_total', current: checkins_total)
    send_event('foursquare_checkins_people', current: checkins_people)
  end
end
