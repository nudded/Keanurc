require 'net/http'
require 'uri'
require 'cgi'
require 'json'

class TranslatePlugin < Plugin

  on_command '!translate' do |query, command|
    query = CGI.escape(query)
    uri = URI.parse 'http://ajax.googleapis.com/'
    request_path = "/ajax/services/language/translate?v=1.0&q=#{query}&langpair=%7Cnl"
    resp = JSON[Net::HTTP.get(uri.host, request_path)]
    command.message = CGI.unescapeHTML(resp['responseData']['translatedText'])
  end

end
