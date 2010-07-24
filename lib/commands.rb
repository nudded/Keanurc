require 'command'
# the NICK command
Command.create 'nick' do
  parse ":nickname"
  param :nickname
end

Command.create 'user' do
  parse ":username :hostname :servername : :realname"

  param :username, :hostname, :servername, :realname do
    default "*"
  end
end
