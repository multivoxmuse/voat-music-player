#\ -w -p 8080
#
## Simple backend for the voat music player
# require 'rack'
# app = Proc.new do |env|
#   puts env
#   [
#     '200', 
#     {'Content-Type' => 'text/html'}, 
#     ["Your env: #{env}"]
#   ]
# end
# Rack::Handler::WEBrick.run app

require 'json'

$voat_api = "https://voat.co/api/"
$voat_endpoints = {
  "subverse_frontpage" => "subversefrontpage?subverse=%{subverse}"
}

def remove_trailing_slashes!(s)
  s = s.slice!(s)
  return s
end

class MyApp
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def status
    if homepage?
      200
    elsif api_request?
      200
    else
      404
    end
  end

  def headers
    {'Content-Type' => 'application/json', 'Content-Length' => body.size.to_s}
  end

  def body
    elsif api_request?
      get_json
    else
      "Page Not Found"
    end

    layout(content)
  end

  private

  def homepage?
    request.path_info =~ /^\/api\/$/
  end

  def api_request?
    request.path_info =~ /^\/api\/v1/
  end

  def get_api_path
    if api_request?
      return request.path_info.partition("/api/v2/").last
    end
  end

  def get_json
    Unirest.get("#{$voat_api}#{voat_endpoints['subverse_frontpage']}" % {:subverse => get_path})
  end

  def load_cache
    JSON.parse(File.read("/tmp/cache/voat-music/#{request.path_info}/cache.json"))
  end

  def save_cache
    File.open("/tmp/cache/voat-music/#{request.path_info}/cache.json", "w") do |cache|
      cache.write(
    end
  end


class MyApp::Rack
  def call(env)
    request = Rack::Request.new(env)
    my_app = MyApp.new(request)

    [my_app.status, my_app.headers, [my_app.body]]
  end
end

run MyApp::Rack.new
