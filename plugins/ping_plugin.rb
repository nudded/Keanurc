class PingPlugin < Plugin
  
  def on_ping(command)
    pong = Command::PONG.new
    pong.message = command.message
    pong
  end

end
