require 'mechanize'
require 'nokogiri'

agent = Mechanize.new
page = agent.get('http://portland.craigslist.org/search/apa/mlt?zoomToPosting=&query=&srchType=A&minAsk=&maxAsk=1200&bedrooms=&addTwo=purrr')
noko = Nokogiri.HTML(page.body)

puts noko.inspect

noko.css('span.pagelinks a').each do |m|
	puts m.to_s
end

noko.css('p.srch').each do |m|
	#puts m.css('span.pl').children.to_s
	puts m.children.to_s
end
