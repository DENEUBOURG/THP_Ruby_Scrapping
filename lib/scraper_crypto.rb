require 'rubygems'
require 'nokogiri'
require 'open-uri'

def scrap_crypto_currencies
    doc = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
    crypto_name_array = []
    table = doc.at('tbody')
    table.search('tr').each do |tr|
        crypto_name_array.insert(-1,{tr.css('.cmc-table__cell--sort-by__name').text => tr.css('.cmc-table__cell--sort-by__price').text}) 
    end
    return crypto_name_array
end

scrap_crypto_currencies