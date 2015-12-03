require 'thor'

module SlackIt
  class Cli < Thor
    desc 'ping', 'send a message'
    option :message, :required => true
    option :channel, :required => true 
    
    def ping 
      send_message(options[:message],options[:channel])
    end

    desc 'pong', 'receive a message'
    def pong
    end
    
    desc 'setup', 'setup your slack account for command line usage'
    def setup
    end
  end
end