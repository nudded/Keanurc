require 'socket'
require 'yaml'

require_relative 'commands'
require_relative 'ping_plugin'
require_relative 'join_plugin'
require_relative 'reconnect_plugin'
require_relative 'twitter_plugin'

class Bot

  def initialize(config_file)
    @config = YAML.load_file config_file 
    @nick = @config.delete 'nick'

    @config.each do |k,v|
      connect k,v['port']
      v['channels'].map! {|c| '#' + c }
      Plugin.plugins << JoinPlugin.new(v['channels'])
    end

    Plugin.plugins.each {|p| p.bot_nick = @nick}
  end

  def self.run(config_file)
    new(config_file).run
  end

  # Run forever, and route incoming messages to the correct plugins
  def run
    join
    loop do
      incoming_sockets = IO.select(sockets.values, nil, nil)
      if incoming_sockets
        incoming_sockets.first.each do |sock|
          parse sock.gets, sock
        end
      end
      sleep 0.2
    end
  end

  private
  
  def join
    nick = Command::NICK.new
    nick.nickname = @nick

    user = Command::USER.new
    user.username = @nick.upcase
    user.realname = @nick

    @config.each do |k,v|
      sockets[k].puts nick.to_irc
      sockets[k].puts user.to_irc
    end
  end

  # Open a connection to the specified `host` and `port`
  def connect(host, port = 6667)
    socket = TCPSocket.new host, port
    sockets[host] = socket
  end

  def parse(string, socket)
    return unless string

    parse_regex = /^(:\S* )?(\d{3}|\w*)(.*)/
    m = parse_regex.match string

    prefix = m[1]
    command_name = m[2]
    params = m[3]

    # if the command is all digits, we need to prepend 'irc'
    if command_name =~ /^\d{3}$/
      command_name = "irc" + command_name
    end

    klass = Command.const_get command_name.upcase
    command = klass.new
    command.parse_irc_input params
    
    # set the sender
    match = prefix.match(/^:(\w+)!.*$/) if prefix
    command.sender = match[1] if match 

    plugin_commands = []
    Plugin.each do |plugin|
      result = plugin.on(command_name, command)
      plugin_commands << result if result
    end

    plugin_commands.flatten.each {|c| socket.puts c.to_irc }
    puts command.to_irc
  rescue Exception => e
    puts e
    puts string
  end

  def sockets
    @sockets ||= {}
  end

end

if __FILE__ == $0
  Bot.run 'test/server_config.yml'
end
