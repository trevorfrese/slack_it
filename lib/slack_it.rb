# require "slack_it/version"
require 'net/http'
require 'envyable'
require 'json'
Envyable.load('../config/env.yml', 'slack')

SLACK_API_TOKEN = ENV['API_TOKEN']

def api_token_valid?
  url = URI.parse("https://slack.com/api/auth.test?token=#{SLACK_API_TOKEN}&pretty=1")

  request = Net::HTTP::Get.new(url.to_s)
  response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
    http.request(request)
  }
  return JSON.parse(response.body)['ok']
end



puts api_token_valid?

def send_message(message, channel,as_user=nil)
  url = URI.parse("https://slack.com/api/chat.postMessage?token=#{SLACK_API_TOKEN}&channel=#{channel}&text=#{message}&as_user=#{as_user}&pretty=1")

  request = Net::HTTP::Get.new(url.to_s)
  response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
    http.request(request)
  }
  return JSON.parse(response.body)['ok']
end

puts send_message("somethingelse", "%23testing_slack_it", "trevorfrese")

module SlackIt
  # Your code goes here...
end
