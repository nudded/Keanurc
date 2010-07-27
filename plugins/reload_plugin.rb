class ReloadPlugin < Plugin
  
  def on_privmsg(command)
    if command.message =~ /^!reload$/
      Plugin.reload
      puts "reloaded"
      c = Command::PRIVMSG.new
      c.receiver = command.receiver
      c.message = "testin"
      c
    end
  end


end
