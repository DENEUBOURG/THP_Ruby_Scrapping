require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_deputies_list
    # Get HTML
    doc = Nokogiri::HTML(open("https://www.nosdeputes.fr/deputes"))
    # Build empty array:
    deputies = []
    doc.css('.list_dep').map{|list_dep|
        # Keep only active deputy
        unless list_dep.css('.list_left').text.strip.include?('ancien') == true
            # Get Deputy LastName:
            lastname = list_dep.css('.list_nom').text.split(',')[0].strip
            # Get Deputy Name:
            firstname = list_dep.css('.list_nom').text.split(',')[1].strip
            # Build Deputy Profile URL:
            url = ("https://www.nosdeputes.fr").concat(list_dep.css('span').map{|value| value['title']}[0])
            # Build an Hash, and insert it in deputies Array
            deputies.insert(-1,{"lastname" => lastname, "firstname" => firstname, "url"=> url})
        end
    }
    #Return Array
    return deputies
end

def get_deputy_email(url)
    # Get HTML
    deputy_html = Nokogiri::HTML(open(url))
    deputy_html.search('a').map{|a|
        # Keep only @assemblee-nationale.fr
        unless a.content.include?('@assemblee-nationale.fr') == false
            return a.content
        end
    }
    # If no @assemblee-nationale.fr addresse found
    return "Non Renseigné"
end

def scrap_deputies
    deputies = get_deputies_list
    deputies.each do |deputy|
        # for each deputy, scrap Web Page, and insert it in Hash
        deputy["email"]  = get_deputy_email(deputy["url"])
        deputy.delete("url")
    end
    return deputies
end

puts deputies_email = scrap_deputies