require 'mechanize'
require 'nokogiri'
require 'sinatra'
require "sinatra/reloader" if development?
require 'data_mapper'
#require 'dm-sqlite-adapter'
require 'dm-postgres-adapter'
require_relative 'scraper'
require 'iconv'
require_relative 'helpers'

DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(4000)
#DataMapper.setup(:default, "sqlite://#{File.expand_path(File.dirname(__FILE__))}/houses.sqlite")
DataMapper.setup(:default, "postgres://localhost/houses")

Dir.glob("models/*.rb").each { |file| require_relative file }

DataMapper.finalize
DataMapper.auto_upgrade!

class FartFilter < Sinatra::Base

	get '/' do
		erb :listings, :locals => {uri_prefix: uri_prefix, listings: get_display}
	end

	get "/update" do
		get_update
		redirect to "/"
	end

	get "/filters" do
		uri_prefix = request.url
		uri_prefix.gsub! /\/[^\/]+$/, ""
		puts uri_prefix
		erb :filters, :locals => {uri_prefix: uri_prefix, filters: Filter.all}
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
end
