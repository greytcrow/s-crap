require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'httparty'

def get_email(address)
	unparsed_page = HTTParty.get("#{address}")#recupre le code de l'addresse passer en parametre de la methode
	parsed_page = Nokogiri::HTML(unparsed_page)# parse la page
	titles = parsed_page.css('small').text.split(' ')#recupure le champ "commune de ..." et le separe en array
	containers = parsed_page.css('td')#parse les valeur des case de renseignement
	size = containers.size
	cont_arr = Array.new
	for i in 0...size do
		cont_arr[i] = containers[i].text
		if cont_arr[i].include?('@')#separe l'adresse e-mail
			duet = Hash.new
			duet = {titles[2] => cont_arr[i]}#crée le hash
			return duet
		end
	end
end

def val_d_oise
	unparsed_page = HTTParty.get("https://www.annuaire-des-mairies.com/val-d-oise.html")
	parsed_page = Nokogiri::HTML(unparsed_page)
	href = parsed_page.css('a.lientxt') # recupere les balises des liens ves les pages de chaques villes
	array_nom = []
	links = []
	result = []
	href = parsed_page.css('a.lientxt').each do |x|
		array_nom << x['href'].sub!(".","http://annuaire-des-mairies.com")#remplace href dans l'url par celle de l'annuaire
		links = array_nom.flatten# transform les array en un seul
	end
	i = 0
	links.each do |x|
		result[i] = get_email(x)# recupere les hash des nom de chaque villes et leur addresse email
		i += 1
	end
	return result.keep_if {|score| score.class == Hash }# retire  tout les element indesirable du tableau et renvois le tableau final
end

val_d_oise