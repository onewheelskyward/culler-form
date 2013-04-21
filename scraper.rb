class Scrape
	include DataMapper::Resource

	property :id, Serial
	property :block, String
	property :created_at, DateTime
end
