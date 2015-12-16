require 'thor'

module SlackIt
  class Cli < Thor
    desc 'ping', 'send a message to a channel'
    option :message, :required => true
    option :channel, :required => true
    
    def ping
      SlackIt::send_message(options[:message], options[:channel])
    end

    desc 'pong', 'receive `n` messages from a channel'
    option :channel, :required => true
    option :number_of_messages, :required => true
    def pong
      puts SlackIt::get_messages(options[:channel], options[:number_of_messages])
    end
    
    desc 'setup', 'setup your slack account for command line usage'
    def setup
      puts SlackIt::setup_config_file
    end
  end
end

