require 'spec_helper'

describe Jenkins::Parser do
  before(:each) do
    @parser = Jenkins::Parser.new(nil)
  end

  it "should parse comments" do
    data = {'changeSet' => {'items' => [{'comment' => 'checkin comment 1'} ,{'comment' => 'checkin comment 2'}]}}
    expected_comments = data['changeSet']['items'].inject "" do |comments, item|
      comments += item['comment'] + ";"
    end
    @parser.comments(data).should == expected_comments
  end

  it "should return standard comment when build is forced" do
    data = {'changeSet' => {'items' => nil}}
    @parser.comments(data).should == "No Comment (Forced)"
  end

  it "should calculate total failcount" do
    data = {'actions' => [{'failCount' => 2}, {'failCount' => 3}]}
    @parser.fail_count(data).should == 5
  end
end
