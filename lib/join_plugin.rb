require_relative 'plugin'

class JoinPlugin < Plugin

  def initialize(channels, keys = [])
    @channels, @keys = channels, keys
  end

  def on_376(command)
    command = Command::JOIN.new
    command.channels = @channels 
    command.keys = @keys
    command
  end

end
