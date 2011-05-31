require 'sinatra'
require 'json'

require File.expand_path('../lib/hudson_connector', __FILE__)

get '/' do
  File.read File.join 'public', 'index.htm'
end

get '/builds' do
  build1 = { :job => 'Test', :health => 80, :project => 'Mingle', :committers => 'Derek', :building => false, :status => 'Fail'}
  build2 = { :job => 'Staging', :health => 20, :project => 'Mingle', :committers => 'Sudhindra', :building => false, :status => 'Success'}
  build3 = { :job => 'Production', :health => 60, :project => 'Mingle', :committers => 'Phil', :building => true, :status => 'Success'}
  { :builds => [ build1, build2, build3, RadiatrServer.new.latest_build({ :project => "Twist"}) ] }.to_json
end

class RadiatrServer
  include HudsonConnector
end
