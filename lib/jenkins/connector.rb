module Jenkins
  class Connector
    attr_reader :url, :user, :password
    attr_accessor :fetcher, :parser

    def initialize(args)
      args.each do |key, value|
        instance_variable_set "@#{key}", value
      end
      @fetcher = Jenkins::Fetcher.new(@url, @user, @password)
      @parser = Jenkins::Parser.new(@fetcher)
    end

    def latest_build
      @parser.parse
    rescue => e
      puts e.inspect
      puts e.backtrace
      { :job => "Connection error" }
    end

    def connector; "Jenkins"; end
  end
end
