require 'nokogiri'
require 'open-uri'

class NowPlayingPlugin < Plugin
 
  on_command '!nowplaying' do |query, response|
    case query
      when 'stubru'
        doc = Nokogiri::XML(open('http://internetradio.vrt.be/internetradio_master/productiesysteem2/song_noa/noa_41.xml'))
        item = doc.xpath('//item[@index=0]').first
        title  = item.xpath('title/titlename').first.inner_text
        artist = item.xpath('artist/artistname').first.inner_text
        response.message = artist.empty? ? title : "#{artist} - #{title}"
      else
        response.message = "tscheelt dak weet oedak moe opzoeken wa der op “#{query}” aant spelen is maat"
    end
  end

end