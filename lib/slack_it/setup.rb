require 'json'
require 'net/http'

module SlackIt
  def self.api_token_nil_or_empty?(api_token_from_cli)
    return api_token_from_cli.nil? || api_token_from_cli.empty?
  end

  def self.create_config_file(api_token)
    Dir.mkdir("config") unless File.exists?("config")
    File.open("config/env.yml", "w+") {|f| f.write("slack: \n"); f.write("  API_TOKEN: #{api_token}")}
  end

  def self.api_token_valid?(api_token)
    url = URI.parse("https://slack.com/api/auth.test?token=#{api_token}&pretty=1")

    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
      http.request(request)
    }
    return JSON.parse(response.body)['ok']
  end

  #puts accept_api_token_from_cli

  def self.accept_api_token_from_cli
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

  def self.setup_config_file
    accept_api_token_from_cli
  end
end
