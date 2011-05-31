require File.expand_path("../../../lib/radiatr_server", __FILE__)

describe RadiatrServer do

  before do
    @server = RadiatrServer.new({:projects => [{:project => "one"}, {:project => "two"}], :connector => 'jenkins'})
  end

  xit "should pass along project configs to connector" do
    @server.builds[0][:project].should == "one"
    @server.builds[1][:project].should == "two"
  end

  it "should pick a connector based on the config" do
    @server.connector.should be_an_instance_of JenkinsConnector
  end

  it "should have a nil connecter if not given one" do
    RadiatrServer.new({:projects => [{:project => "one"}, {:project => "two"}]}).connector.should be_nil
  end
end
