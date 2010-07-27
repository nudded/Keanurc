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

end
