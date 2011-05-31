require File.expand_path("../../../lib/jenkins_connector", __FILE__)

describe JenkinsConnector do
  it 'put the configured project name into the output' do
    expected_name = "Test Project"
    JenkinsConnector.new.latest_build({:project => expected_name})[:project].should == expected_name
  end
end
