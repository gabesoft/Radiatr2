require 'spec_helper'

describe Jenkins::Connector do
  it 'should initialize url' do
    Jenkins::Connector.new(url: "test").url.should == "test"
  end

  it 'should initialize user' do
    Jenkins::Connector.new(user: "test").user.should == "test"
  end

  it 'should initialize password' do
    Jenkins::Connector.new(password: "test").password.should == "test"
  end

  it 'should initialize a fetcher' do
    Jenkins::Connector.new({}).fetcher.should_not be_nil
  end

  it 'should initialize a parser' do
    Jenkins::Connector.new({}).parser.should_not be_nil
  end

  it 'should get the data from the fetcher' do
    connector = Jenkins::Connector.new(url: 'testurl')
    connector.fetcher.should_receive(:fetch).with('testurl/api/json')
    connector.fetcher.should_receive(:fetch).with('testurl/lastBuild/api/json')
    connector.parser.should_receive(:parse)
    connector.latest_build
  end

  it 'should parse the data' do
    connector = Jenkins::Connector.new(url: 'testurl')
    connector.fetcher.should_receive(:fetch).with('testurl/lastBuild/api/json').and_return('one')
    connector.fetcher.should_receive(:fetch).with('testurl/api/json').and_return('two')
    connector.parser.should_receive(:parse).with('one', 'two')
    connector.latest_build
  end

  it 'should print connection error as job name on 404' do
    connector = Jenkins::Connector.new(url: 'http://fakeurl/should/404')
    connector.latest_build[:job].should == "Connection error"
  end
end
