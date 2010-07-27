require 'imdb'
require 'cgi'

module Imdb
  class Search < MovieList
    def self.query(query)
      open("http://www.imdb.com/search/title?title=#{CGI::escape(query)}&title_type=feature") 
    end
  end
end
class IMDBPlugin < Plugin
  
  def on_privmsg(command)
    if command.message =~ /!imdb (.*)/
      query = Imdb::Search.new $1
      c = Command::PRIVMSG.new
      c.receiver = command.receiver
      c.message = query.movies.first.url rescue c.message = "no results"
      c
    end
  end

end
