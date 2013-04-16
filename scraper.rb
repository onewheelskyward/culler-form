require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{File.expand_path(File.dirname(__FILE__))}/scraper.sqlite")

class Scrape
	include DataMapper::Resource

	property :id, Serial
	property :block, String, :length => 2000
	property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!
