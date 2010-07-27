require 'socket'
require 'yaml'

require_relative 'commands'

class Bot

  def initialize(config_file)
    @config = YAML.load_file config_file 
    @config.each do |k,v|
      connect k,v['port']
    end
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
    @config.each do |k,v|
      nick = Command::NICK.new
      nick.nickname = v['nick']

      user = Command::USER.new
      user.username = v['nick'].upcase
      user.realname = v['nick']

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
    command = m[2]
    params = m[3]

    klass = Command.const_get command.upcase
    command = klass.new
    command.parse_irc_input params
    
    puts command.to_irc
  end

  def sockets
    @sockets ||= {}
  end

end

if __FILE__ == $0
  Bot.run 'test/server_config.yml'
end
