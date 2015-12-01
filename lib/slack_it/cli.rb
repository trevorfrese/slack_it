require 'thor'

module SlackIt
  class Cli < Thor
    desc 'ping', 'send a message'
    def ping
    end

    desc 'pong', 'receive a message'
    def pong
    end
  end
end
