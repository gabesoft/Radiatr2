require 'spec_helper'

describe JenkinsConnector do
  xit 'put the configured project name into the output' do
    expected_name = "Test Project"
    build = JenkinsConnector.new.latest_build({:project => expected_name,
                                               :url => "url"})
    build[:project].should == expected_name
  end

  it "should parse comments" do
    build = JenkinsConnector.new
    data = {'changeSet' => {'items' => [{'comment' => 'checkin comment 1'} ,{'comment' => 'checkin comment 2'}]}}
    expected_comments = data['changeSet']['items'].inject "" do |comments, item|
      comments += item['comment'] + ";"
    end
    comments = build.comments data

    comments.should == expected_comments
  end

  it "should return standard comment when build is forced" do
    build = JenkinsConnector.new
    data = {'changeSet' => {'items' => nil}}
    comments = build.comments data

    comments.should == "No Comment (Forced)"
  end

  it "should calculate total failcount" do
    build = JenkinsConnector.new
    data = {'actions' => [{'failCount' => 2}, {'failCount' => 3}]}

    fail_count = build.fail_count_from_data data
    fail_count.should == 5
  end

  it 'should print connection error as job name on 404' do
    build = JenkinsConnector.new
    latest_build = build.latest_build({ "url" => 'http://fakeurl/should/404' })
    latest_build[:job].should == "Connection error"
  end

  it 'should not send login information if it is not provided' do
    data = { :url => "url" }
    build = JenkinsConnector.new
    build.has_login?(data).should be_false
  end

  it 'should send login information if it is provided' do
    data = { :url => "url", :user => "user", :password => "password" }
    build = JenkinsConnector.new
    build.has_login?(data).should be_true
  end
end
