require 'sinatra'
require 'json'

set :port, 5555

get '/lastBuild/api/json' do
  result = rand(2) == 1 ? "SUCCESS" : "FAILURE";  
  response = {"actions"=>[{"causes"=>[{"shortDescription"=>"Started by an SCM change"}]},{},{}, {"failCount"=>1, "skipCount"=>0, "totalCount"=>4, "urlName" =>"testReport"}],"building"=>true,"description"=>"des","duration"=>0,"fullDisplayName"=>"MyTestBuild #1","id"=>"2011-03-02_13-50-56","keepLog"=>false,"number"=>765,"result"=>result,"timestamp"=>1299102656450,"url"=>"http://build.com.com:8080/job/BUILD/1/","builtOn"=>"testr8","changeSet"=>{"items"=>[{"comment"=>"#{Time.now} SMAC - 7643 - STORY_TITLE ( Ken ) : migrated StepPanelUnitTest and UserSelectionUnitTest to jasmine","date"=>2199101901000,"domain"=>"null","items"=>[{"action"=>"edit","editType"=>"edit","path"=>"changeset path"},{"action"=>"add","editType"=>"add","path"=>"changeset path"},{"action"=>"add","editType"=>"add","path"=>"changeset path"},{"action"=>"delete","editType"=>"delete","path"=>"changeset path"},{"action"=>"delete","editType"=>"delete","path"=>"changeset path"},{"action"=>"edit","editType"=>"edit","path"=>"changeset path"},{"action"=>"edit","editType"=>"edit","path"=>"changeset path"}],"user"=>"RaoSu01","version"=>"2382"},{"comment"=>"code project fix (Jim)","date"=>1299102590000,"domain"=>"null","items"=>[{"action"=>"edit","editType"=>"edit","path"=>"changeset path"}],"user"=>"RaoSu01","version"=>"2385"},{"comment"=>"code project fix (Joe)","date"=>1299102635000,"domain"=>"null","items"=>[{"action"=>"edit","editType"=>"edit","path"=>"changeset path"}],"user"=>"RaoSu01","version"=>"2386"}],"kind"=>"null"},"culprits"=>[{"absoluteUrl"=>"http=>//build.com.com=>8080/user/RaoSu01","fullName"=>"RaoSu01"}]}
  response.to_json
end

get '/api/json' do
  result = rand(2) == 1 ? "SUCCESS" : "FAILURE";  
  response = {"buildable"=> true, "lastSuccessfulBuild"=> {"number" => 700}, "lastUnsuccessfulBuild" => {"number" =>  760}, "healthReport"=>[{"score" => 50}]}
  response.to_json
end

# not_found do  
#   status 404  
#   'not found'  
# end