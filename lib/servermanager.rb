require 'socket'
require 'singleton'
require 'yaml'

class ServerManager

  include Singleton

  def initialize
    @config = YAML.load_file('server_config.yml') 
    @config.each do |k,v|
      connect k,v['port']
    end
  end

  def self.run
    instance.run
  end

  # Run forever, and route incoming messages to the correct plugins
  def run
    sockets['wina.ugent.be'].puts "NICK nuddedtestbot"
    sockets['wina.ugent.be'].puts "USER nuddedtestbot * * :nuddedtestbot"
    loop do
      incoming_sockets = IO.select(sockets.values, nil, nil)
      if incoming_sockets
        incoming_sockets.first.each do |sock|
          parse sock.gets
        end
      end
      sleep 0.2
    end
  end

  # Send the message. (the host will be set in the Message object)
  def send(message)
    sockets[message.host].send message.to_irc
  end

  private
  
  # Open a connection to the specified `host` and `port`
  def connect(host, port = 6667)
    socket = TCPSocket.new host, port
    sockets[host] = socket
  end

  # TODO implement this bitch
  def parse(string)
    return unless string

    parse_regex = /^(:\S* )?(\d{3}|\w*)(.*)/
    m = parse_regex.match string

    prefix = m[1]
    command = m[2]
    params = m[3]

    puts "#{prefix}#{command}#{params}"
  end

  def sockets
    @sockets ||= {}
  end

end
