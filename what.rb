require 'mechanize'
require 'nokogiri'
require 'sinatra'
require "sinatra/reloader" if development?
require 'data_mapper'
require 'dm-sqlite-adapter'
require_relative 'scraper'

DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(4000)
DataMapper.setup(:default, "sqlite://#{File.expand_path(File.dirname(__FILE__))}/houses.sqlite")

class Listing
	include DataMapper::Resource

	property :id, Serial
	property :date, String
	property :link_url, String
	property :link_text, String
	property :price, Integer
	property :sqft, Integer
	property :location, String
	property :display, Boolean, default: true
	property :created_at, DateTime
end

class Filter
	include DataMapper::Resource

	property :id, Serial
	property :pattern, String
	property :type, Enum[:title, :detail, :location]
	property :created_id, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!

# Johnny 5 no disassemble!
def disassemble(html)
	ret = {}
	#'<span class="i">&nbsp;</span> <span class="pl"> <span class="itemdate">Apr 16</span> <a href="http://portland.craigslist.org/mlt/apa/3748006047.html">Bay windows-May move in available</a> </span> <span class="itempnr"> $635 / 1br - 769ft&sup2; -  <span class="itempp"></span> <small> (Portland)</small> </span>  <span class="itempx"> <span class="p"> img&nbsp;<a href="#" class="maptag" data-pid="3748006047">map</a></span></span> <br class="c">'
	html.match(/\<span class=\"itemdate\"\>(\w+ \d+)\<\/span>/)
	ret[:date] = $1

	html.match(/<a href="([^"]+)">([^>]+)<\/a>/)
	ret[:link_url] = $1
	ret[:link_text] = $2

	html.match(/\$(\d+)/)
	ret[:price] = $1.to_i

	html.match(/(\d+)ft/)
	ret[:sqft] = $1.to_i

	match = html.match(/\<small>\s*\(([^\)]+)\)\<\/small\>/)
	ret[:location] = $1

	ret
end

def filter
	filters = Filter.all
	Listing.all.each do |listing|
		filters.all.each do |filter|
			case filter.type
				when :title
					if listing.link_text =~ /#{filter.pattern}/i
						listing.display = false
						listing.save
					end
				when :location
					if listing.location =~ /#{filter.pattern}/i
						listing.display = false
						listing.save
					end
			end
		end
	end
end

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
		Scrape.first_or_create(block: m.children.to_s)
		Listing.first_or_create(disassemble(m.children.to_s))
	end

	filter
end

def display
	Listing.all(display: true, :order => [:created_at.desc])
end

get '/' do
	erb :listings, :locals => {listings: display}
end

get "/update" do
	update
	redirect to "/"
end

get "/filters" do
	erb :filters, :locals => {filters: Filter.all}
end

post "/filters" do
	Filter.create(params)
	redirect to "/filters"
end

get "/rm_filter/:id" do
	Filter.get(params[:id].to_i).destroy
	redirect to "/filters"
end

get "/update_filters" do
	filter
	redirect to "/filters"
end
