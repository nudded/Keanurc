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
      m = command.message.match(/^#{com}(.*)$/)
      resp = respond(command) 
      query = m[1].strip rescue nil 

      call_args = [query, resp, command.sender]
      response = block.call *call_args[0..block.arity] if m
      responses << response
    end
    responses.compact
  end

  def method_missing(name, *args)
    super unless name =~ /^on_(\w*)$/
  end

end
