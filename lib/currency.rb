require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'httparty'

unparsed_page = HTTParty.get("https://coinmarketcap.com/all/views/all/")
parsed_page = Nokogiri::HTML(unparsed_page)
nok_currency_name = parsed_page.css('td.text-left.col-symbol')
nok_currency_value = parsed_page.css('a.price')
size = nok_currency_name.size
currency_name = Array.new
currency_value = Array.new
currency_listing = Array.new
for i in 0...size do
	currency_name[i] = nok_currency_name[i].text.gsub('$','')
	currency_value[i] = nok_currency_value[i].text
	#currency_listing[i] = Hash.new
	currency_listing[i] = {currency_name[i] => currency_value[i]}
end  
