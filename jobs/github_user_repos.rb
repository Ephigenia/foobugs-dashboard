require 'net/http'
require 'json'

# github_username = 'users/ephigenia'
github_username = 'orgs/foobugs'
max_length = 5
ordered = true

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new("api.github.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new("/#{github_username}/repos"))
  data = JSON.parse(response.body)

  if response.code != "200"
    puts "github api error (status-code: #{response.code})\n#{response.body}"
  else
    repos_forks = Array.new
    repos_watchers = Array.new
    data.each do |repo|
      repos_forks.push({
        label: repo['name'],
        value: repo['forks']
      })
      repos_watchers.push({
        label: repo['name'],
        value: repo['watchers']
      })
    end

    if ordered
      repos_forks = repos_forks.sort_by { |obj| -obj[:value] }
      repos_watchers = repos_watchers.sort_by { |obj| -obj[:value] }
    end

    send_event('github_user_repos_forks', { items: repos_forks.slice(0, max_length) })
    send_event('github_user_repos_watchers', { items: repos_watchers.slice(0, max_length) })

  end # if

end # SCHEDULER