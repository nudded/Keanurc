class Plugin
  
  def self.inherited(new_plugin)
    plugins << new_plugin
  end

  def self.plugins
    @plugins ||= []
  end

  def each(&b)
    plugins.each &b
  end

end
