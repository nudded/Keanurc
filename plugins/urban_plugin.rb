require 'nokogiri'
require 'net/http'
require 'uri'
require 'cgi'

class UrbanPlugin < Plugin
  
  on_command '!urban' do |query, response|
    begin
      html = Net::HTTP.get(URI.parse "http://www.urbandictionary.com/define.php?term=#{CGI.escape query}")
      doc = Nokogiri::HTML.parse html
      definition = doc.xpath("//div[@class='definition']").first.text
      response.message = query + ': ' + definition
    rescue
      response.message = "No results"
    end
  end

end
