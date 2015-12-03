
# require "slack_it/version"
require "invoke_call/version"
require File.dirname(__FILE__) +  "/slack_it/cli"
require 'net/http'
require 'envyable'
require 'json'

SLACK_API_TOKEN = ENV['API_TOKEN']

module SlackIt
  def api_token_nil_or_empty?(api_token_from_cli)
    return api_token_from_cli.nil? || api_token_from_cli.empty?
  end

  def create_config_file(api_token)
    Dir.mkdir("config") unless File.exists?("config")
    File.open("config/env.yml", "w+") {|f| f.write("slack: \n"); f.write("  API_TOKEN: #{api_token}")}
  end

  def api_token_valid?(api_token)
    url = URI.parse("https://slack.com/api/auth.test?token=#{api_token}&pretty=1")

    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
      http.request(request)
    }
    return JSON.parse(response.body)['ok']
  end

#puts accept_api_token_from_cli

Envyable.load('config/env.yml', 'slack')
SLACK_API_TOKEN = ENV['API_TOKEN']

  def accept_api_token_from_cli
    puts "Please go to https://api.slack.com/web and issue an API token for your team. Then copy and paste that API token here."
    api_token_from_cli = gets.chomp
    if api_token_nil_or_empty?(api_token_from_cli)
      return "Error: API token was empty. Please re-enter it."
    elsif !api_token_valid?(api_token_from_cli)
      return "Error: API token was invalid, please reissue a new one and re-enter it."
    else
      create_config_file(api_token_from_cli)
    end
    return "You entered a successful API token! Now you can send slack messages from your terminal."
  end

  puts accept_api_token_from_cli
  
  def send_message(message, channel,as_user=nil)
    url = URI.parse("https://slack.com/api/chat.postMessage?token=#{SLACK_API_TOKEN}&channel=#{channel}&text=#{message}&as_user=#{as_user}&pretty=1")

    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
      http.request(request)
    }
    return JSON.parse(response.body)['ok']
  end
end
