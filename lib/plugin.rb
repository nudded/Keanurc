class Plugin
 
  attr_accessor :bot_nick

  def self.inherited(new_plugin)
    plugins << new_plugin.new
  end

  def self.plugins
    @plugins ||= []
  end

  def self.each(&b)
    plugins.each &b
  end

  def self.load_plugins(dir_name = 'plugins')
    Dir["#{dir_name}/*.rb"].each {|plugin| require plugin}
  end

  def on(name, command)
    send("on_#{name.downcase}", command)
  end 

  def method_missing(name, *args)
    super unless name =~ /^on_(\w*)$/
  end

end
