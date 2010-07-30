class ReconnectPlugin < Plugin
  
  def on_kick(command)
    if command.user.downcase == bot_nick.downcase
      c = Command::JOIN.new
      c.channels << command.channel
    end
  end

end
