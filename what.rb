require 'mechanize'
require 'nokogiri'
require_relative 'scraper'
require 'sinatra'

def update
	agent = Mechanize.new
	page = agent.get('http://portland.craigslist.org/search/apa/mlt?zoomToPosting=&query=&srchType=A&minAsk=&maxAsk=1200&bedrooms=&addTwo=purrr')
	noko = Nokogiri.HTML(page.body)

	puts noko.inspect

	# Not going to worry about what's in the past for now.
	#noko.css('span.pagelinks a').each do |m|
	#	puts m.to_s
	#end

	noko.css('p.srch').each do |m|
		#puts m.css('span.pl').children.to_s
		scrape = Scrape.first_or_create(block: m.children.to_s)
	end
end

def display
	returns = []
	Scrape.all.each do |m|
		unless m.block =~ /apartment/i or m.block =~ /condo/i or m.block =~ /gresham/i or m.block =~ /Beaverton/i or m.block =~ /Hillsdale/ or m.block =~ /Gateway/i
			returns.push m.block
		end
	end
	returns
end

get '/display' do
	display
end

get '/' do
	display
end

get "/update" do
	update
	redirect to "/display"
end
