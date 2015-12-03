require File.dirname(__FILE__) +  "/slack_it/version"
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

  def self.get_messages(channel, number_of_messages)
    url = URI.parse("https://slack.com/api/channels.history?token=#{SLACK_API_TOKEN}&channel=#{channel}&count=#{number_of_messages}&pretty=1")

    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
      http.request(request)
    }

    if JSON.parse(response.body)['ok']
      list_of_messages = JSON.parse(response.body)['messages']
      messages_list = []
      list_of_messages.each do |message|
         if message['user']
           url = URI.parse("https://slack.com/api/users.info?token=#{SLACK_API_TOKEN}&user=#{message['user']}&pretty=1")

           request = Net::HTTP::Get.new(url.to_s)
           response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
             http.request(request)
           }

           response = JSON.parse(response.body)

           if response['ok']
             hash = {}
             hash[response['user']['name']] = message['text']
             messages_list.push(hash)
           else
             puts response['error']
           end
         end

         if message['username']
           hash = {}
           hash[message['username']] = message['text']
           messages_list.push(hash)
         end
      end

      return messages_list
    else
      return JSON.parse(response.body)['error']
    end
  end
end
