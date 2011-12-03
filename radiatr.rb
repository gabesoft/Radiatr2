class Radiatr < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/' do
    File.read File.join 'public', 'index.htm'
  end

  get '/builds' do
    { :builds => RadiatrServer.new(config).builds }.to_json
  end

  get '/mingle/*' do
    content_type "application/json"

    path = "/" + params["splat"].join
    query = params.except("splat")

    response = Pringle::MingleClient.new(config[:mingle]).query(path, query)

    case response.code.to_i
    when 200
      json = ActiveSupport::JSON.encode(response.deserialise)
      if params[:callback]
        body "#{params[:callback]}(#{json});"
      else
        body json
      end
    when 400..599
      status response.code.to_i
      body ActiveSupport::JSON.encode(:error => "Error", :uri => path, :text => response.body)
    end
  end

  def config
    config = YAML::load File.open 'config.yaml'
    sorted_projects = config["jenkins"].values.sort_by {|b| b['order'] }
    { :projects => sorted_projects, :connector => 'jenkins', :mingle => config["mingle"] }
  end
end
