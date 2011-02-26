#encoding:utf-8
require 'hpricot'
require 'open-uri'
require 'iconv'

INFO = {}
a = Time.now
file = File.new("tete", "w:utf-8")
doc = Hpricot.parse(open("http://www.dianping.com/shop/2015683"), :encoding=>"utf-8")
#puts doc
  (doc/"form").each do |element|
    puts element
    #element.css("dl").each_with_index do |info, index|
      #case info.at_css("dt").content
      #when "商户描述:"
        #INFO[:detail] = info.at_css("dd").content
        #file.puts INFO[:detail]
      #when "推荐菜:"
        #INFO[:recommend] = info.at_css("dd").content
        #file.puts INFO[:recommend]
      #else
        
      #end
    #end
  end
  file.close

puts Time.now - a
