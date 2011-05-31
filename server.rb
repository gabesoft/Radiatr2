require 'sinatra'
require 'json'

require File.expand_path('../lib/hudson_connector', __FILE__)

get '/' do
  File.read File.join 'public', 'index.htm'
end

get '/builds' do
  # Read the YAML file. Not sure how to do this. We then
  # pass the config into the connector.
  { :builds => [ RadiatrServer.new.latest_build({}) ] }.to_json
end

class RadiatrServer
  include HudsonConnector

  def latest_build config
    { :error => "Please select a connector!" }
  end
end
