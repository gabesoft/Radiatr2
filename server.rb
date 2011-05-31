require 'sinatra'
require 'json'

require File.expand_path('../lib/radiatr_server', __FILE__)

get '/' do
  File.read File.join 'public', 'index.htm'
end

get '/builds' do
  # Read the YAML file. Not sure how to do this. We then
  # pass the config into the server.
  { :builds => RadiatrServer.new({}).builds }.to_json
end
