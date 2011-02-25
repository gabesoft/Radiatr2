require 'sinatra'
require 'json'

get '/lastBuild/api/json' do
  result = rand(2) == 1 ? "SUCCESS" : "FAILURE";  
  response = {"actions" => [{"building" => false, "result" => result, "changeSet" => { "items" => [{"comment" => "checkin comment #{Time.now}"}]} }] }
  response.to_json
end