require File.expand_path("../../../lib/radiatr_server", __FILE__)

describe RadiatrServer do

  before do
    @server = RadiatrServer.new([{:project => "one"}, {:project => "two"}])
  end

  it "should pass along configs to connector" do
    @server.builds[0][:project].should == "one"
    @server.builds[1][:project].should == "two"
  end
end
