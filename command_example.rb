require 'command'
Command.create 'join' do

  parse "[:channels] [:keys] : :message"

  # Fine grained control
  param :channels do
    default []
    join do |channels|
      channels.join ',' 
    end
  end
  
  # Handy defaults
  comma_separated_array :keys

  param :message

end
c = Command::JOIN.new
c.parse_irc_input '#zeus,#wina test :testing test'
p c.channels
p c.keys
p c.message
