require 'command'
Command.create 'join' do

  parse "[:channels] [:keys]"

  param :channels do
    default []
    join do |channels|
      channels.join ',' 
    end
  end
  
  # Fine grained control
  param :keys do
    default []
    join do |keys|
      keys.join ','
    end
  end

  # Handy defaults
  comma_separated_array :channels, :keys

end
c = Command::JOIN.new
c.parse_irc_input '#zeus,#wina test'
p c.channels
p c.keys
