require 'sinatra'
require 'json'

get '/' do
  File.read File.join 'public', 'index.htm'
end

get '/builds' do
  build1 = { :job => 'Test', :health => 80, :project => 'GMail', :committers => 'Derek', :building => false, :status => 'Fail'}
  build2 = { :job => 'Staging', :health => 20, :project => 'GMail', :committers => 'Sudhindra', :building => false, :status => 'Success'}
  build3 = { :job => 'Production', :health => 60, :project => 'GMail', :committers => 'Phil', :building => true, :status => 'Success'}
  { :builds => [ build1, build2, build3 ] }.to_json
end
