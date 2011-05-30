require 'sinatra'
require 'json'

get '/' do
  File.read File.join 'public', 'index.htm'
end
