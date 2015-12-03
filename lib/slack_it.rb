require "slack_it/version"
require File.dirname(__FILE__) +  "/slack_it/cli"
require File.dirname(__FILE__) +  "/slack_it/setup"
require 'net/http'
require 'envyable'
require 'json'

Envyable.load('config/env.yml', 'slack')
SLACK_API_TOKEN = ENV['API_TOKEN']

module SlackIt
  def self.send_message(message, channel,as_user=nil)
    url = URI.parse("https://slack.com/api/chat.postMessage?token=#{SLACK_API_TOKEN}&channel=#{channel}&text=#{message}&as_user=#{as_user}&pretty=1")

    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
      http.request(request)
    }

    return JSON.parse(response.body)['ok']
  end
end
