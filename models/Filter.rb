class Filter
	include DataMapper::Resource

	property :id, Serial
	property :pattern, String
	property :type, Enum[:title, :detail, :location]
	property :created_id, DateTime
end
