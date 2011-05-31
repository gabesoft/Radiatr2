require File.expand_path("../../../lib/hudson_connector", __FILE__)

describe :HudsonConnector do
  it 'put the configured project name into the output' do
    expected_name = "Test Project"
    HudsonConnector.new.latest_build({:project => expected_name})[:project].should == expected_name
  end
end
