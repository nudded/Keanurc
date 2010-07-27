require_relative 'command'

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

Command.create 'notice' do
  parse ':nickname : :text'
  param :nickname, :text
end

Command.create 'error' do
  parse ': :message'
  param :message
end

Command.create 'ping' do
  parse ':message'
  param :message
end

Command.create 'pong' do
  parse ':message'
  param :message
end
