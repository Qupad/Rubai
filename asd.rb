require 'nokogiri'
require 'open-uri'

puts "Write URL"
url = gets.chomp
puts "File name"
name = gets.chomp
href = []
hash = {}
loop do
page_m = Nokogiri::HTML(open(url))
page_m.xpath('//a[@class="product_img_link"]').each do |node| 
	href << node.xpath('./@href').text
end
print href
puts href.size
href.each do |uri|
	page = Nokogiri::HTML(open(uri))
	title = page.xpath('//h1[@class="nombre_producto"]/text()').text.strip
	image = page.xpath('(//img[@itemprop="image"]/@src)[1]').text
	page.xpath('//ul[@class="attribute_labels_lists"]').each do |node|
		gramm = node.xpath('.//span[@class="attribute_name"]/text()').text.strip
		hash[gramm] = node.xpath('.//span[@class="attribute_price"]').text.strip
	end
	hash.each { |gramm, price| File.open(name + ".txt", 'a'){ |file| file.puts  "title: #{title} - #{gramm} \nprice: #{price} \nimage: #{image} \n"} }
	hash.clear
end
next_p = page_m.xpath('//a[@rel="next"]/@href').text
href.clear
hash.clear
puts next_p
break if next_p.empty?
url = "https://www.petsonic.com" + next_p
end