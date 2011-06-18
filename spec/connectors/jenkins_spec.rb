require 'spec_helper'

describe JenkinsConnector do
  xit 'put the configured project name into the output' do
    expected_name = "Test Project"
    build = JenkinsConnector.new.latest_build({:project => expected_name,
                                               :url => "url"})
    build[:project].should == expected_name
  end
end
