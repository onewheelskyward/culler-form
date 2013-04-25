class Listing
	include DataMapper::Resource

	property :id, Serial
	property :date, String
	property :link_url, String
	property :link_text, String
	property :price, Integer
	property :sqft, Integer
	property :location, String
	property :get_display, Boolean, default: true
	property :created_at, DateTime

	has 1, :detail
end
