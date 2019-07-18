require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'httparty'
def get_email(address)
	unparsed_page = HTTParty.get("#{address}")
	parsed_page = Nokogiri::HTML(unparsed_page)
	titles = parsed_page.css('small').text.split(' ')
	containers = parsed_page.css('td')
	size = containers.size
	cont_arr = Array.new
	for i in 0...size do
		cont_arr[i] = containers[i].text
		if cont_arr[i].include?('@')
			duet = Hash.new
			duet = {titles[2] => cont_arr[i]}
			return duet
		end
	end
end

def val_d_oise
	unparsed_page = HTTParty.get("https://www.annuaire-des-mairies.com/val-d-oise.html")
	parsed_page = Nokogiri::HTML(unparsed_page)
	href = parsed_page.css('a.lientxt')
	array_nom = []
	links = []
	result = []
	href = parsed_page.css('a.lientxt').each do |x|
		array_nom << x['href'].sub!(".","http://annuaire-des-mairies.com")
		links = array_nom.flatten
	end
	i = 0
	links.each do |x|
		result[i] = get_email(x)
		i += 1
	end
	return result.keep_if {|score| score.class == Hash }
end

val_d_oise