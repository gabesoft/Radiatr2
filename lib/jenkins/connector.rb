module Jenkins
  class Connector
    attr_reader :url, :user, :password
    attr_accessor :fetcher, :parser

    def initialize(args)
      args.each do |key, value|
        instance_variable_set "@#{key}", value
      end
      @fetcher = Jenkins::Fetcher.new(@user, @password)
      @parser = Jenkins::Parser.new(@fetcher)
    end

    def latest_build
      full_data = @fetcher.fetch(full_data_url)
      data = @fetcher.fetch(data_url)
      @parser.parse(data, full_data)
    rescue => e
      puts e.inspect
      puts e.backtrace
      { :job => "Connection error" }
    end

    def full_data_url
      @url + '/api/json'
    end

    def data_url
      @url + '/lastBuild/api/json'
    end

    def connector; "Jenkins"; end
  end
end
