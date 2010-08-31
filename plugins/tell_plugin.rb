class TellPlugin < Plugin

  on_command '!tell' do |query, response, sender|
    query = query.split
    to = query.delete_at 0
    self.add_tell(to, to + ': ' + self.make_timestamp + " <#{sender}> " + query.join(' '))
    response.message = "I'll pass that on when #{to} is around."
  end

  def on_privmsg(command)
    super_result = super
    tells = self.class.tells(command.sender)
    if tells
      c = respond(command) 
      tells.map! do |message|
        c.dup.tap {|com| com.message = message}
      end
      self.class.clear_tells command.sender
    else
      tells = []
    end
    (tells + super_result).flatten.compact
  end

  def self.add_tell(to, message)
    self.store.sadd "tells_#{to}", message
  end
  
  def self.clear_tells(user)
    self.store.del "tells_#{user}"
  end

  def self.tells(user)
    self.store.smembers "tells_#{user}"
  end

end
