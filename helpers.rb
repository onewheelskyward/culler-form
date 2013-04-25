
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

def filter_listing(filter, field, filter_check)
	if filter_check =~ /#{filter.pattern}/i
		field.display = false
		field.save
	end
end

def filter
	filters = Filter.all
	Listing.all.each do |listing|
		filters.all.each do |filter|
			case filter.type
				when :title
					filter_listing(filter, listing, listing.link_text)
				when :location
					filter_listing(filter, listing, listing.location)
				when :detail
					if listing.detail
						filter_listing(filter, listing, listing.detail.html)
					end
			end
		end
	end
end

def get_update
	agent = Mechanize.new
	agent.user_agent_alias = 'Linux Firefox'

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
		listing = Listing.first_or_create(disassemble(m.children.to_s))
		detail_page = agent.get(listing.link_url)
		sleep(3)
		Detail.first_or_create(listing: listing, html: Iconv.conv("UTF8", "LATIN1", detail_page.body))
	end

	filter
end

def get_display
	Listing.all(get_display: true, :order => [:created_at.desc])
end

