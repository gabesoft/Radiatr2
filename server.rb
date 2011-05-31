require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'net/http'

require File.expand_path('../lib/radiatr_server', __FILE__)

get '/' do
  File.read File.join 'public', 'index.htm'
end

get '/builds' do
  { :builds => RadiatrServer.new(config).builds }.to_json
end

def config
  config = YAML::load File.open 'config.yaml'
  { :projects => config.values, :connector => 'jenkins' }
end
