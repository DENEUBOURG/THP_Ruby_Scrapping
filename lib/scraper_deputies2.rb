require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_deputies_list
    doc = Nokogiri::HTML(open("https://www.nosdeputes.fr/deputes"))
    deputies = []
    #Get Deputy Web Page:
    doc.css('.list_dep').map{|list_dep|
        lastname = list_dep.css('.list_nom').text.split(',')[0].strip
        firstname = list_dep.css('.list_nom').text.split(',')[1].strip
        url = ("https://www.nosdeputes.fr").concat(list_dep.css('span').map{|value| value['title']}[0])
        unless list_dep.css('.list_left').text.strip.include?('ancien') == true
            deputies.insert(-1,{"lastname" => lastname, "firstname" => firstname, "url"=> url})
        end
    }
    return deputies
end

def get_deputy_email(url)
    deputy_html = Nokogiri::HTML(open(url))
    deputy_html.search('a').map{|a|
        unless a.content.include?('@assemblee-nationale.fr') == false
            return a.content
        end
    }
    return "Non Renseigné"
end

def scrap_deputies
    deputies = get_deputies_list
    deputies.each do |deputy|
        deputy["email"]  = get_deputy_email(deputy["url"])
        deputy.delete("url")
    end
    return deputies
end

puts deputies_email = scrap_deputies