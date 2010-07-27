require_relative 'plugin'

class ReconnectPlugin < Plugin
  
  def on_kick(command)
    if command.user == bot_nick
      c = Command::JOIN.new
      c.channels << command.channel
      c
    else
      nil
    end
  end

  def on_privmsg(command)
    if command.message == 'Wie is er de max?'
      c = Command::PRIVMSG.new
      c.receiver = command.receiver
      c.message = command.sender + ': ' + 'you are, sir'
      c
    end
  end

end
