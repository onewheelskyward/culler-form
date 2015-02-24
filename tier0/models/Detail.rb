class Detail
	include DataMapper::Resource

	property :id, Serial
	property :html, Text
	property :created_at, DateTime

	belongs_to :listing
end
