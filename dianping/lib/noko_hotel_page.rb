#encoding:utf-8
require 'nokogiri'
require 'open-uri'
require 'iconv'

INFO = {}
COM = []
a = Time.now
file = File.new("tete", "w:utf-8")
doc = Nokogiri::HTML.parse((open("http://www.dianping.com/shop/529488")),nil, "utf-8")
  doc.xpath('//form/div/div/div/div/div/dl/dd').each do |element|
    puts "#############"
    puts element
  end
  doc.xpath('//form/div/div/div/div/dl/dd').each do |element|
    puts "#############"
    puts element
  end
  doc.css("dl.reviewMix").each do |element|
    puts detail = element.at_css("dd").content
  end

  doc.css("dl.contList").each do |element|
    comment = {}
    comment[:con] = element.at_css(".contList-con").content
    puts comment[:con]
    file.puts comment[:con]
    comment[:date] = element.at_css("span.review-date").content
    file.puts comment[:date]
    puts comment
    COM << comment
  end
  file.close

puts Time.now - a
