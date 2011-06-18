class RadiatrServer
  attr_reader :connector

  def initialize config
    @projects = config[:projects]
    jenkins = config[:connector] and config[:connector].downcase == "jenkins"
    @connector = JenkinsConnector.new if jenkins
  end

  def builds
    @projects.inject [] do |sum, config|
      sum << @connector.latest_build(config)
    end
  end
end
