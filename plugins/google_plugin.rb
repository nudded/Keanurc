require 'google-search'

class GooglePlugin < Plugin

  on_command '!g' do |query, response|
    search = Google::Search::Web.new :query => query
    message = search.first.uri + " || " + "http://www.google.be/search?&q=#{Google::Search.url_encode(search.query)}"
    response.message = message
    response
  end

end
