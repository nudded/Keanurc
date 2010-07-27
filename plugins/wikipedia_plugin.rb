require 'cgi'
require 'net/http'
require 'nokogiri'

class WikiPediaPlugin < Plugin
  def on_privmsg(command)
    if command.message =~ /^!w(u|i)k (.*)/
      c = Command::PRIVMSG.new
      c.receiver = command.receiver
      
      url = URI.parse("http://en.wikipedia.org/w/index.php?title=Special%3ASearch&search=" + CGI.escape($2))
      resp = Net::HTTP.get_response url
      
      url = resp['location']
      puts url
      if url
        doc = Nokogiri::HTML.parse(open(url))
        el = doc.xpath("//div[@id='bodyContent']/p").first
        begin
          short_content = el.text.split(/\n|\. [A-Z]/).first
          p short_content
          if short_content =~ / may refer to:$/
            short_content = doc.xpath("//div[@id='bodyContent']/ul").first.text.split("\n").first
          end
        rescue
          short_content = "Start the #{$2} article, using the Article Wizard if you wish, or add a request for it."
        end
        c.message = '"' + short_content + '" - ' + url  
      else
        c.message = "No results"
      end
      c
    end
  end
end
