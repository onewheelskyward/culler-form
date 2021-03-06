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
		erb :listings, :locals => {uri_prefix: get_uri_prefix, listings: get_display}
	end

	get "/update" do
		get_update
		erb :listings, :locals => {uri_prefix: get_uri_prefix, listings: get_display}
	end

	get "/filters" do
		erb :filters, :locals => {uri_prefix: get_uri_prefix, filters: Filter.all}
	end

	post "/filters" do
		Filter.create(params)
		erb :filters, :locals => {uri_prefix: get_uri_prefix, filters: Filter.all}
	end

	get "/rm_filter/:id" do
		Filter.get(params[:id].to_i).destroy
		erb :filters, :locals => {uri_prefix: get_uri_prefix, filters: Filter.all}
	end

	get "/update_filters" do
		filter
		erb :filters, :locals => {uri_prefix: get_uri_prefix, filters: Filter.all}
	end
end
