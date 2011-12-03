require 'spec_helper'

describe RadiatrServer do

  before do
    @server = RadiatrServer.new({:projects => [{:project => "one"}, {:project => "two"}], :connector => 'jenkins'})
  end

  xit "should pass along project configs to connector" do
    @server.builds[0][:project].should == "one"
    @server.builds[1][:project].should == "two"
  end
end
