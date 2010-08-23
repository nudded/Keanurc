require 'nokogiri'
require 'open-uri'
require 'json'
require 'net/http'

class NowPlayingPlugin < Plugin
 
  on_command '!nowplaying' do |query, response|
    case query
      when 'stubru'
        doc = Nokogiri::XML(open('http://internetradio.vrt.be/internetradio_master/productiesysteem2/song_noa/noa_41.xml'))
        item = doc.xpath('//item[@index=0]').first
        title  = item.xpath('title/titlename').first.inner_text
        artist = item.xpath('artist/artistname').first.inner_text
        message = artist.empty? ? title : "#{artist} - #{title}"
        json_res = JSON[Net::HTTP.get(URI.parse("http://gdata.youtube.com/feeds/api/videos?q=#{URI.escape message}&max-results=1&alt=json&restricion=157.193.55.235"))]
        link = json_res['feed']['entry'].first['link'].first['href'] rescue nil
        response.message = link.nil? ? message : "#{message} -- #{link}"
      else
        response.message = "tscheelt dak weet oedak moe opzoeken wa der op \"#{query}\" aant spelen is maat"
    end
  end

end
