require 'sinatra'
require 'json'

get '/lastBuild/api/json' do
  result = rand(2) == 1 ? "SUCCESS" : "FAILURE";  
  response = {"actions"=>[{"causes"=>[{"shortDescription"=>"Started by an SCM change"}]}],"building"=>true,"description"=>"des","duration"=>0,"fullDisplayName"=>"AuthorSpace-SMAC #765","id"=>"2011-03-02_13-50-56","keepLog"=>false,"number"=>765,"result"=>result,"timestamp"=>1299102656450,"url"=>"http://build.zynx.com:8080/job/Authorspace-SMAC/765/","builtOn"=>"testr8","changeSet"=>{"items"=>[{"comment"=>"#{Time.now} SMAC - 7643 - STORY_TITLE ( Ken ) : migrated StepPanelUnitTest and UserSelectionUnitTest to jasmine","date"=>1299101901000,"domain"=>"null","items"=>[{"action"=>"edit","editType"=>"edit","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Zynx.AuthorSpace.UI.Web.Unit.csproj"},{"action"=>"add","editType"=>"add","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Javascript/JasmineStepPanelUnitTest.js"},{"action"=>"add","editType"=>"add","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Javascript/JasmineUserSelectionUnitTest.js"},{"action"=>"delete","editType"=>"delete","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Javascript/StepPanelUnitTest.js;X334"},{"action"=>"delete","editType"=>"delete","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Javascript/UserSelectionUnitTest.js;X334"},{"action"=>"edit","editType"=>"edit","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Javascript/WorkflowJasmineUnitTest.html"},{"action"=>"edit","editType"=>"edit","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Javascript/WorkflowUnitTest.html"}],"user"=>"RaoSu01","version"=>"2382"},{"comment"=>"code project fix (Jim)","date"=>1299102590000,"domain"=>"null","items"=>[{"action"=>"edit","editType"=>"edit","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Zynx.AuthorSpace.UI.Web.Unit.csproj"}],"user"=>"RaoSu01","version"=>"2385"},{"comment"=>"code project fix (Joe)","date"=>1299102635000,"domain"=>"null","items"=>[{"action"=>"edit","editType"=>"edit","path"=>"$/ZynxTechnology/1.Main/CTSv02/IIS/Code/01 UserInterface/Authorspace/Tests/v2.0/Unit/Zynx.AuthorSpace.UI.Web.Unit.csproj"}],"user"=>"RaoSu01","version"=>"2386"}],"kind"=>"null"},"culprits"=>[{"absoluteUrl"=>"http=>//build.zynx.com=>8080/user/RaoSu01","fullName"=>"RaoSu01"}]}
  response.to_json
end

get '/api/json' do
  result = rand(2) == 1 ? "SUCCESS" : "FAILURE";  
  response = {"buildable"=> true, "lastSuccessfulBuild"=> {"number" => 700}, "lastUnsuccessfulBuild" => {"number" =>  760}}
  response.to_json
end

not_found do  
  status 404  
  'not found'  
end