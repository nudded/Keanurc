require 'google-search'

class GooglePlugin < Plugin
  
  def on_privmsg(command)
    if command.message =~ /^!g (.*)/
      search = Google::Search::Web.new :query => $1
      message = search.first.uri + " || " + "http://www.google.be/search?&q=#{Google::Search.url_encode(search.query)}"
      c = Command::PRIVMSG.new
      c.receiver = command.receiver
      c.message = message
      c
    end
  end

end
