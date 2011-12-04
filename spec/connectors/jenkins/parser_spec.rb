require 'spec_helper'

describe Jenkins::Parser do
  before(:each) do
    @parser = Jenkins::Parser.new({})
  end

  it "should parse comments" do
    data = {'changeSet' => {'items' => [{'comment' => 'checkin comment 1'} ,{'comment' => 'checkin comment 2'}]}}
    @parser.fetcher.should_receive(:fetch).with("/lastBuild/api/json").and_return(data)
    expected_comments = data['changeSet']['items'].inject "" do |comments, item|
      comments += item['comment'] + ";"
    end
    @parser.comments.should == expected_comments
  end

  it "should return standard comment when build is forced" do
    data = {'changeSet' => {'items' => nil}}
    @parser.fetcher.should_receive(:fetch).with("/lastBuild/api/json").and_return(data)
    @parser.comments.should == "No Comment (Forced)"
  end

  it "should calculate total failcount" do
    data = {'actions' => [{'failCount' => 2}, {'failCount' => 3}]}
    @parser.fetcher.should_receive(:fetch).with("/lastBuild/api/json").and_return(data)
    @parser.fail_count.should == 5
  end

  it "should return the result for a finished job" do
    @parser.fetcher.should_receive(:fetch).with("/lastBuild/api/json").twice.and_return({ "result" => "broken" })
    @parser.status.should == 'broken'
  end

  it "should get the result of the previous build for a non-finished job" do
    @parser.fetcher.should_receive(:fetch).with("/lastBuild/api/json").and_return({ })
    @parser.fetcher.should_receive(:fetch).with("/lastCompletedBuild/api/json").and_return({ "result" => 'broken' })
    @parser.status.should == 'broken'
  end

end
