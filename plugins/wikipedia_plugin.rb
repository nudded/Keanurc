require 'cgi'
require 'net/http'
require 'nokogiri'

class WikiPediaPlugin < Plugin

  on_command '!wik' do |query, response|
    self.search(query, response)
  end

  on_command '!wuk' do |query, response|
    self.search(query, response)
  end

  def self.search(query, response)
    url = URI.parse("http://en.wikipedia.org/w/index.php?title=Special%3ASearch&search=" + CGI.escape(query))
    resp = Net::HTTP.get_response url

    url = resp['location']
    if url
      doc = Nokogiri::HTML.parse(open(url))
      el = doc.xpath("//div[@id='bodyContent']/p").first
      begin
        short_content = el.text.split(/\n|\. [A-Z]/).first
        if short_content =~ / may refer to:$/
          short_content = doc.xpath("//div[@id='bodyContent']/ul").first.text.split("\n").first
        end
        short_content << '.'
      rescue
        short_content = "Start the #{$2} article, using the Article Wizard if you wish, or add a request for it."
      end
      response.message = '"' + short_content + '" - ' + url
    else
      response.message = "No results"
    end
  end

end 
