require 'rexml/document'
require 'net/http'

class NowPlayingPlugin < Plugin
  
  on_command '!nowplaying' do |query, response, sender|
    doc = Net::HTTP.get URI.parse("http://internetradio.vrt.be/internetradio_master/productiesysteem2/song_noa/noa_41.xml")
    xml = REXML::Document.new doc        
    info = REXML::XPath.each(xml, "//item[@index=0]//titlename | //item[@index=0]//artistname").map(&:text)
    response.message = "#{sender}: #{info[1]} - #{info[3]}" 
  end

end
