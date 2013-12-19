#!/usr/bin/env ruby
require 'net/http'
require 'openssl'
require 'json'

# This job will track metrics of a github organisation or user

# Config
# ------
# example for tracking single user repositories
github_username = ENV['GITHUB_USERINFO_USERNAME'] || 'users/ephigenia'
# example for tracking an organisations repositories
# github_username = 'orgs/foobugs'

SCHEDULER.every '3m', :first_in => 0 do |job|
  http = Net::HTTP.new("api.github.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # disable ssl certificate check
  response = http.request(Net::HTTP::Get.new("/#{github_username}"))
  data = JSON.parse(response.body)

  if response.code != "200"
    puts "github api error (status-code: #{response.code})\n#{response.body}"
  else
    send_event('github_userinfo_followers', current: data['followers'])
    send_event('github_userinfo_following', current: data['following'])
    send_event('github_userinfo_repos', current: data['public_repos'])
    send_event('github_userinfo_gists', current: data['public_gists'])
  end
end