class TellPlugin < Plugin

  on_command '!tell' do |query, response|
    query = query.split
    to = query.delete_at 0
    tells[to] << to + ': ' + Time.now.strftime("%H:%M") + "<#{sender}>" + query.join(' ')
    response.message = "I'll pass that on when #{to} is around."
  end

  def on_privmsg(command)
    super_result = super
    tells = self.class.tells[command.sender]
    unless tells.empty?
      c = respond(command) 
      tells.map! do |message|
        c.dup.tap {|com| com.message = message}
      end
      self.class.tells[command.sender] = []
    end
    (tells + super_result).flatten.compact
  end

  def self.tells
    store['tells'] = Hash.new {|h,k| h[k] = [] } unless store['tells']
    store['tells']
  end

end
