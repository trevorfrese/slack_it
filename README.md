A simple command line interface for talking to slack

## Usage

Use

    $ slackit setup
    
to configure your account


Use

    $ slackit ping #MESSAGE# #CHANNEL#
    
to send a message


Use 

    $ slackit pong #CHANNEL# #n# 
    
to pull the last `n` messages from a channel.


At this point:

Use

    $ cd lib/
    $ ruby slack_it.rb ping --channel=#CHANNEL# --message=#MESSAGE#

to send a message