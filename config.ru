require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongoid'
require 'mongo'
require "./main.rb"

Dir["./models/**/*.rb"].each { |model| require model }

Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('jokes')
  end
end

run Application