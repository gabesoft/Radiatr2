require File.expand_path('../hudson_connector', __FILE__)

class RadiatrServer
  include HudsonConnector

  def initialize config
    @projects = config[:projects]
  end

  def builds
    @projects.inject [] do |sum, config|
      sum << latest_build(config)
    end
  end
end
