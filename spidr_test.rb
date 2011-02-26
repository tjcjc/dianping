#encoding:utf-8
require 'nokogiri'
require 'open-uri'
require 'iconv'


def html_unescape(s)
  return s unless s
  s.gsub(/&(\w+|#[0-9]+);/) { |match|
    number = case match
             when /&(\w+);/
               Nokogiri::HTML::NamedCharacters[$1]
             when /&#([0-9]+);/
               $1.to_i
             end
  puts number

  key = number ? ([number].pack('U*') rescue match) : match
  puts "地址"
  puts key
  key
  }
end

INFO = {}
COM = []

puts a = Time.now
URL = "http://www.dianping.com/search/category/8/10/g446p1/g10g446"
#must add the last utf-8
file = File.new("te", "w:utf-8")
doc = Nokogiri::HTML.parse((open("http://www.dianping.com/search/category/8/10/g446p1/g10g446")),nil, "utf-8")
doc.css(".box dl dd").each_with_index do |element, index|
  next if index == 0
  price = element.at_css("strong.average").content[/[0-9]+/]
  file.puts price
  path = element.at_css("a.BL")["href"]
  name = element.at_css("a.BL")["name"]
  file.puts name
  address = element.at_css("li.address").to_s.gsub(/\<.+?\>/ ,"").gsub("地址: ", "")
  telephone = address.slice!(/[0-9]+$/)
  file.puts address
  file.puts telephone
  hotel_page = Nokogiri::HTML.parse((open("http://www.dianping.com#{path}")),nil, "utf-8")
  hotel_page.xpath('//form/div/div/div/div/div/dl/dd').each do |element|
    puts "#############"
    puts element
  end
  hotel_page.xpath('//form/div/div/div/div/dl/dd').each do |element|
    puts "#############"
    puts element
  end
  hotel_page.css("dl.reviewMix").each do |element|
    puts detail = element.at_css("dd").content
  end

  hotel_page.css("dl.contList").each do |element|
    comment = {}
    comment[:con] = element.at_css(".contList-con").content
    puts comment[:con]
    file.puts comment[:con]
    comment[:date] = element.at_css("span.review-date").content
    file.puts comment[:date]
    puts comment
    COM << comment
  end
end
file.close
puts Time.now - a


