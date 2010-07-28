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
  
  on_command '!imdb' do |query, response|
    message = Imdb::Search.new(query).movies.first.url rescue "No results"
    response.message = message
    response
  end

end
