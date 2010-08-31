# A plugin that allows users to query when a another user was last active on the
# channel. This plugin uses the redis store to persist data.
#
class SeenPlugin < Plugin

  # Seen command: query the redis store for the given user
  #
  on_command '!seen' do |query, response|
    response.message = self.last_seen query
  end

  # On any message: update the redis store
  #
  def on_privmsg(command)
    super_result = super
    self.class.see command.sender, command.receiver, command.message
    super_result
  end

  # When was the given user last seen? This function returns a descriptive
  # string.
  #
  def self.last_seen(user)
    message = self.store.get "seen_message_#{user}"
    channel = self.store.get "seen_channel_#{user}"
    time = self.store.get "seen_time_#{user}"
    if message and time and channel then
      "#{user} was last seen in #{channel} on #{time} saying: #{message}"
    else
      "I've never seen #{user} here!"
    end
  end

  # See the user: this will update the timestamp and the last message of the
  # user.
  #
  def self.see(user, channel, message)
    self.store.set "seen_message_#{user}", message
    self.store.set "seen_channel_#{user}", channel
    self.store.set "seen_time_#{user}", self.make_timestamp
  end

end
