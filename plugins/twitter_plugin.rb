require 'twitter'

class TwitterPlugin < Plugin

  on_command '!twitter' do |query, response|
    begin
      tweet = Twitter.user(query).status
      message = '@' + query + ': ' + tweet.text  
      link = response.dup
      link.message = "http://twitter.com/#{query}"
      response.message = message
      [response, link]
    rescue
      response.message = "hmm, bestaat niet sorry"
    end
  end

end
