class RadiatrServer
  attr_reader :connector

  def initialize config
    @projects = config[:projects]
    @jenkins = config[:connector] and config[:connector].downcase == "jenkins"
  end

  def builds
    @projects.inject [] do |sum, config|
      sum << Jenkins::Connector.new(config).latest_build
    end
  end
end
