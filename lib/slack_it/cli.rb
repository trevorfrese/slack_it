require 'thor'

module SlackIt
  class Cli < Thor
    desc 'ping', 'send a message'
    option :message, :required => true
    option :channel, :required => true
    option :number_of_messages, :required => true
    
    def ping 
      send_message(options[:message],options[:channel])
    end

    desc 'pong', 'receive a message'
    def pong
    end
    
    desc 'setup', 'setup your slack account for command line usage'
    def setup
      setup_config_file
    end
  end
end

