require_relative 'plugin'

class PingPlugin < Plugin
  
  def on_ping(command)
    puts "test"
    pong = Command::PONG.new
    pong.message = command.message
    pong
  end

end
