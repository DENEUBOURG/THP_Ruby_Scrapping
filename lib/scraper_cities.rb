require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_cities_list
    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
    cities =[]
    # Get City Web Page
    doc.search('table').each do |info|
        info.search('a').css('.lientxt').map{|a|
            url = a['href']
            url.slice!(0)
            url = ("http://annuaire-des-mairies.com/").concat(url)
            cities.insert(-1,{"name" => a.content,"url" => url})
        }
    end
    return cities
end

def get_city_email(url)
    city_html = Nokogiri::HTML(open(url))
    city_html.search('td').each do |td|
        unless td.content.include?('@') == false
            return td.content
        end
    end
    return "Non renseigné"
end

def scrap_city_townhall
    cities = get_cities_list
    cities.each do |city|
        city["email"]  = get_city_email(city["url"])
        city.delete("url")
    end
    return cities
end

puts city_email = scrap_city_townhall
