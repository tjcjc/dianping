#encoding:utf-8
require 'nokogiri'
require 'open-uri'
require 'iconv'

puts a = Time.now
INDEX = "http://www.dianping.com"
URL = "http://www.dianping.com/search/category/8/10/g446p1/g10g446"
INTRO_INFO = {"餐厅特色" => "feature=", "餐厅氛围" => "atomosphere=", "网友推荐" => "recommend="}
chengdu_url = "http://www.dianping.com/shopall/8/10"

def make_tags_for_city(district_div, city)
  district_div.css("dl.list").each do |district_element|
    district_name = district_element.at_css("dt a").content
    dist = District.new
    dist.city = city
    dist.name = district_name
    district_element.css("dd ul li").each do |street_element|
      street = Street.new
      street.name = street_element.at_css("a").content
      dist.streets << street
      street.save
    end
    dist.save
  end
  city.save
end

def get_hotels_by_city(city_url)
  doc = Nokogiri::HTML.parse((open(city_url)),nil, "utf-8")
  city_name = doc.at_css("div.content_b h1.shopall strong").content[0..-5]
  @city = City.new(:name => city_name)
  doc.css("div.main_w div.shopallCate").reverse_each do |element|
    if element.at_css("h2").content =~ /商区/
      Rails.logger.info "########make_tags start_time #{Time.now}"
      make_tags_for_city(element, @city)
      Rails.logger.info "########make_tags finish_time #{Time.now}"
    #get all the tasts category div in this city
    elsif element.at_css("dl dt a").content == "美食"
      Rails.logger.info "########get_hotels by cate start_time #{Time.now}"
      element.css("dl dd ul li").each do |link|
        cate_link = INDEX + link.at_css("a")["href"]
        cate = link.at_css("a").content
        get_hotels_by_cate(cate_link, cate)
      end
      Rails.logger.info "########get_hotels by cate finish_time #{Time.now}"
    end
  end
end

def get_hotels_by_cate(cate_url, cate)
  category = Category.find_or_create_by(:name => cate)
  Rails.logger.info category
  while
    doc = Nokogiri::HTML.parse((open(cate_url)),nil, "utf-8")
    #get all hotels info div in this category
    doc.css(".box dl dd").each_with_index do |element, index|
      Rails.logger.info "########get_hotels information start_time #{Time.now}"
      next if index == 0
      name = element.at_css("a.BL").content
      hotel = Hotel.first(:conditions => {:name => name})
      Rails.logger.info "hotel ##### #{hotel} #####"
      unless hotel
        @hotel = Hotel.create
        @hotel.name = name
        @hotel.city = @city
        @hotel.category = category
        @hotel.delicious = element.at_css("span.score1").content.to_i
        @hotel.environment = element.at_css("span.score2").content.to_i
        @hotel.server = element.at_css("span.score3").content.to_i
        @hotel.price = element.at_css("strong.average").content[/[0-9]+/]
        set_hotel_feeling
        address = element.at_css("li.address").to_s.gsub(/\<.+?\>/ ,"").gsub("地址: ", "")
        telephone = address.slice!(/[0-9]+$/)
        @hotel.telephone = telephone
        @hotel.address = address
        @hotel.url = INDEX + element.at_css("a.BL")["href"]
        set_hotel_detail_info_by_hotel_url
        @hotel.save
      end
      Rails.logger.info "########get_hotels information finish_time #{Time.now}"
    end
    break unless next_page_path = doc.at_css("a.NextPage")
    cate_url = INDEX + next_page_path["href"]
  end
end

def set_hotel_feeling
  @hotel.feeling = (@hotel.delicious + @hotel.environment + @hotel.server) / 3
end

def set_hotel_detail_info_by_hotel_url
  hotel_page = Nokogiri::HTML.parse((open(@hotel.url)),nil, "utf-8")
  tags_str = hotel_page.at_css("div.ShopGuide").content
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  Rails.logger.info tags_str
  make_tags_for_hotel(tags_str)
  set_intro_info(hotel_page.css("dl.intro"))
  set_detail_info(hotel_page)
  set_comment_info(hotel_page)
end

def set_comment_info(page)
  page.css("dl.contList").each do |element|
    comment = Comment.new
    comment.content = element.at_css(".contList-con").content
    comment.date = element.at_css("span.review-date").content[0..13]
    @hotel.comments << comment
    comment.save
  end
end

def set_detail_info(page)
  @hotel.detail = page.at_css("dl.reviewMix dd").content if page.at_css("dl.reviewMix dd")
end

def set_intro_info(intro_div)
  intro_div.each do |dl|
    con = dl.at_css("dt").content
    info_con = dl.at_css("dd").content
    if INTRO_INFO.keys.include?(con)
      formated_info = format_intro_info(info_con)
      if con == "网友推荐"
        formated_info.split("  ").each do |dish|
          @hotel.dishes << Dish.find_or_create_by(:name => dish)
        end
      else
        @hotel.send(INTRO_INFO[con], formated_info)
      end
    else
      set_bus_info(info_con)
    end
  end
end

def set_bus_info(info_str)
  info_str.scan(/\d+/).each do |bus|
    @hotel.buses << Bus.find_or_create_by(:number => bus)
  end
end

def format_intro_info(info_str)
  info_str.gsub(/\(.+?\)/, "")[0..-8]
end

def make_tags_for_hotel(tags_str)
  tags = tags_str.strip.gsub(">","").split("  ")[1..-3]
  if tags.size > 0
    Rails.logger.info "########{tags}    @#****************"
  @hotel.district =  District.find_or_create_by(:name => tags[0]) 
  end
  if tags.size == 2
  @hotel.street = Street.find_or_create_by(:name => tags[1]) 
  end
end
