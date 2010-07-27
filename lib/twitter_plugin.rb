require_relative 'plugin'
require 'twitter'

class TwitterPlugin < Plugin

  def on_privmsg(command)
    if command.message =~ /^!twitter (\w*)$/
      c = Command::PRIVMSG.new
      c.receiver = command.receiver
      link = c.dup
      begin
        tweet = Twitter.user($1).status
        message = '@' + $1 + ': ' + tweet.text  
        c.message = message
        link.message = "http://twitter.com/#{$1}"
        [c, link]
      rescue 
        c.message = "hmm, bestaat niet"
        c
      end
    end
  end

end
