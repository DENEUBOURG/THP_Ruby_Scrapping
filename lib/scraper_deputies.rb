require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_deputies_list
    doc = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
    deputies = []
    #Get Deputy Web Page:
    table = doc.at('div[id=deputes-list]')
    table.search('a').map{|a|
        unless (a['href'].is_a? String) == false
            url = ("http://www2.assemblee-nationale.fr").concat(a['href'])
            deputies.insert(-1,{"name" => a.content,"url" => url})
        end
    }
    return deputies
end

def get_deputy_email(url)
    deputy_html = Nokogiri::HTML(open(url))
    deputy_html.search('a').map{|a|
        unless a.content.include?('@') == false
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