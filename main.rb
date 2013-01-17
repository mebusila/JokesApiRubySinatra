require 'rubygems'
require 'sinatra'

get '/:name' do
  "Hello param, #{params[:name]}"
end