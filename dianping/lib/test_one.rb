#encoding:utf-8
require 'nokogiri'
require 'open-uri'

INTRO_INFO = {"餐厅特色" => "feature=", "餐厅氛围" => "atmosphere=", "网友推荐" => "recommend="}
INDEX = "http://www.dianping.com"

def make_tags_for_city(district_div)
  district_div.css("dl.list").each do |district_element|
    puts district_name = district_element.at_css("dt a").content
    #dist = District.new
    #dist.name = district_name
    district_element.css("dd ul li").each do |street_element|
      #street = Street.new
      puts name = street_element.at_css("a").content
      #dist.streets << street
      #street.save
    end
    #dist.save
  end
end

def get_hotels_by_city(city_url)
  doc = Nokogiri::HTML.parse((open(city_url)),nil, "utf-8")
  doc.css("div.main_w div.shopallCate").reverse_each do |element|
    if element.at_css("h2").content =~ /商区/
      make_tags_for_city(element)
    #get all the tasts category div in this city
    elsif element.at_css("dl dt a").content == "美食"
      element.css("dl dd ul li").each do |link|
        cate_link = INDEX + link.at_css("a")["href"]
        puts cate = link.at_css("a").content
        get_hotels_by_cate(cate_link, cate)
      end
    end
  end
  doc.css("div.main_w div.shopallCate").each do |element|
    if element.at_css("h2").content =~ /商区/
      make_tags_for_city(element)
    #get all the tasts category div in this city
    elsif element.at_css("dl dt a").content == "美食"
      element.css("dl dd ul li").each do |link|
        cate_link = INDEX + link.at_css("a")["href"]
        puts cate = link.at_css("a").content
        get_hotels_by_cate(cate_link, cate)
      end
    end
  end
end

def get_hotels_by_cate(cate_url, cate)
  #unless category = Category.find_by_name(cate)
    #category = Category.new(:name => cate)
  #end
  #get all hotels info div in this category
  while(true)
  doc = Nokogiri::HTML.parse((open(cate_url)),nil, "utf-8")
  doc.css(".box dl dd").each_with_index do |element, index|
    next if index == 0
    puts name = element.at_css("a.BL").content
    #hotel = Hotel.find_by_name(name)
    #unless hotel
      #@hotel = Hotel.new
      #@hotel.name = name
      #@hotel.category = category
      #@hotel.delicious = element.at_css("span.score1").content.to_i
      puts element.at_css("span.score1").content.to_i
      #@hotel.environment = element.at_css("span.score2").content.to_i
      puts element.at_css("span.score2").content.to_i
      #@hotel.server = element.at_css("span.score3").content.to_i
      puts element.at_css("span.score3").content.to_i
      #@hotel.price = element.at_css("strong.average").content[/[0-9]+/]
      puts element.at_css("strong.average").content[/[0-9]+/]
      #set_hotel_feeling
      address =  element.at_css("li.address").to_s.gsub(/\<.+?\>/ ,"").gsub("地址: ", "")
      puts telephone = address.slice!(/[0-9]+$/)
      puts address
      #@hotel.telephone = telephone
      #@hotel.address = address
      #@hotel.url = INDEX + element.at_css("a.BL")["href"]
      puts INDEX + element.at_css("a.BL")["href"]
      url = INDEX + element.at_css("a.BL")["href"]
      set_hotel_detail_info_by_hotel_url(url)
      #@hotel.save
    end
  break unless next_page_path = doc.at_css("a.NextPage")
  cate_url = INDEX + next_page_path["href"]
  end
end
def set_hotel_detail_info_by_hotel_url(url)
 hotel_page = Nokogiri::HTML.parse((open(url)),nil, "utf-8")
  tags_str = hotel_page.at_css("div.ShopGuide").content
  make_tags_for_hotel(tags_str)
  set_intro_info(hotel_page.css("dl.intro"))
  set_detail_info(hotel_page)
  set_comment_info(hotel_page)
end

def set_comment_info(page)
  page.css("dl.contList").each do |element|
    #comment = Comment.new
    #comment.content = element.at_css(".contList-con").content
    puts element.at_css(".contList-con").content
    #comment.date = element.at_css("span.review-date").content[0..13]
    puts element.at_css("span.review-date").content[0..13]
    #@hotel.comments << comment
  end
end

def set_detail_info(page)
  #@hotel.detail = page.at_css("dl.reviewMix dd").content
  if con = page.at_css("dl.reviewMix dd")
  puts con.content
  end
end

def set_intro_info(intro_div)
  intro_div.each do |dl|
    con = dl.at_css("dt").content
    info_con = dl.at_css("dd").content
    if INTRO_INFO.keys.include?(con)
      formated_info = format_intro_info(info_con)
      if con == "网友推荐"
        formated_info.split("  ").each do |dish|
          #@hotel.dishes << Dish.find_or_create_by(:name => dish)
          puts dish
        end
      else
        #@hotel.send(INTRO_INFO[con], formated_info(info_con))
        puts formated_info.split(" ")
      end
    else
      set_bus_info(info_con)
    end
  end
end

def set_bus_info(info_str)
  info_str.scan(/\d+/).each do |bus|
    #@hotel.buses << Bus.find_or_create_by(:number => bus)
    puts bus
  end
end

def format_intro_info(info_str)
  info_str.gsub(/\(.+?\)/, "")[0..-8]
end

def make_tags_for_hotel(tags_str)
  puts tags_str.strip
str = "成都餐厅 > 金牛区 > 茶店子 > 川菜  大蓉和酒楼(一品天下店)"
  #tags = tags_str.gsub!(">", "").split("  ")[1..-3]
  tags = tags_str.strip.split(" > ")[1..-3]
  puts tags
  puts str.strip.gsub(">","").split("  ")
  #@hotels.district =  District.find_or_create_by(:name => tags[0]) if tags.size > 0
  #@hotels.street = Street.find_or_create_by(:name => tags[1]) if tags.size == 2
end

set_hotel_detail_info_by_hotel_url("http://www.dianping.com/shop/2887807")
#get_hotels_by_city("http://www.dianping.com/shopall/8/10")
