require File.expand_path('../hudson_connector', __FILE__)

class RadiatrServer
  include HudsonConnector

  def initialize config
    @config = config
  end

  def builds
    @config[:projects].inject [] do |sum, config|
      sum << latest_build(config)
    end
  end
end
