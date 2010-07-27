class Plugin
 
  attr_accessor :bot_nick

  def self.inherited(new_plugin)
    plugins << new_plugin.new
  end

  def self.reload
    # i hate the joinplugin, it's really ugly, but i really have to remove it
    # here
    @plugins.delete_if {|plu| plu.class == JoinPlugin} 
    @plugins.each do |plu|
      Object.class_eval {remove_const plu.class.name.to_sym}
    end
    @plugins = []
    load_plugins @plugin_dir
  end

  def self.plugins
    @plugins ||= []
  end

  def self.each(&b)
    plugins.dup.each &b
  end

  def self.load_plugins(dir_name = 'plugins')
    @plugin_dir = dir_name
    Dir["#{dir_name}/*.rb"].each {|plugin| load plugin}
  end

  def on(name, command)
    send("on_#{name.downcase}", command)
  end 

  def method_missing(name, *args)
    super unless name =~ /^on_(\w*)$/
  end

end
