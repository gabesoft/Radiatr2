class Radiatr < Sinatra::Base
  set :root, File.dirname(__FILE__)
  
  get '/' do
    File.read File.join 'public', 'index.htm'
  end

  get '/builds' do
    { :builds => RadiatrServer.new(config).builds }.to_json
  end

  def config
    config = YAML::load File.open 'config.yaml'
    sorted_projects = config.values.sort_by {|b| b['order'] }
    { :projects => sorted_projects, :connector => 'jenkins' }
  end
end