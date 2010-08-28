require 'redis'

class Plugin
 
  attr_accessor :bot_nick

  def self.inherited(new_plugin)
    plugins << new_plugin.new
  end

  class << self
    attr_accessor :plugin_dir
  end

  def self.reload
    @plugins.each do |plu|
      Object.class_eval {remove_const plu.class.name.to_sym} rescue nil
    end
    @plugins = []
    load_plugins
  end

  def self.plugins
    @plugins ||= []
  end

  def self.each(&b)
    plugins.dup.each &b
  end

  def self.load_plugins
    Dir["#{plugin_dir}/*.rb"].each {|plugin| load plugin}
  end

  def self.sleep(time)
    c = Command::SLEEP.new
    c.time = time
    c
  end
 
  def sleep(time)
    self.class.sleep time
  end

  def on(name, command)
    send("on_#{name.downcase}", command)
  end 
  
  # store the block for later
  # the block can take 0, 1, 2 or 3 arguments
  # |query, response, sender| arguments will be left out from right to left
  # call this method in the initialize method
  def self.on_command(command, &block)
    commands[command] = block
  end
  
  def self.commands
    @commands ||= {}
  end

  def respond(command)
    c = Command::PRIVMSG.new
    c.receiver = command.receiver
    c
  end
 
  # do some filtering in the baseclass
  #
  def on_privmsg(command)
    responses = []
    self.class.commands.each do |com,block|
      m = command.message.match(/^#{com} (.*)$/)
      resp = respond(command) 
      query = m[1].strip rescue nil 

      call_args = [query, resp, command.sender]
      response = block.call *call_args[0...block.arity] if m
      if valid_command? response 
        responses << response
        responses.flatten!
      elsif block.arity > 1
        responses << resp if resp.message
      end
    end
    responses.compact
  end

  def valid_command?(potential)
    (potential.is_a?(Array) && potential.all? {|r| r.is_a?(CommandBase)}) || potential.is_a?(CommandBase)
  end

  def self.store
    @store ||= Redis.new 
  end

  def method_missing(name, *args)
    super unless name =~ /^on_(\w*)$/
  end

end
