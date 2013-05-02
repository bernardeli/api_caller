require 'json'

set :public_folder, 'public'
set :static, true

get '/' do
  @endpoints = Endpoint.all
  haml :endpoints
end

get '/request/:route' do
  begin
    endpoint = Endpoint.new(params[:route])
    api_response = JSON.parse(ApiCaller.request(params[:route]))

    @html = CodeRay.scan(JSON.pretty_generate(api_response), :json).div
    @curl = endpoint.as_curl
    @explanation = endpoint.to_s
  rescue
    @html = "It failed!"
    @curl = "It failed!"
    @explanation = "It failed!"
  end

  haml :api_response
end
