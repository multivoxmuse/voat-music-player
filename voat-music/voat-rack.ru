#\ -w -p 8080
## Simple backend for the voat music player

require 'json'
require 'unirest'
require 'fileutils'


$api_version = 'v1'

$voat_api = "https://voat.co/api/"
$voat_endpoints = [
  {"url" => "subversefrontpage?subverse=music", "path" => "voat/subverses/music/"}
]

class MyApp
  # Small rack app
  attr_reader :request
  attr_accessor :body
  attr_accessor :status

  def initialize(request)
    # Gets the work done
    @request = request
    @body = get_json
    @status = status
  end

  def status
    # Return a status code
    if @body
      200
    else
      400
    end
  end

  def headers
    # Response headers
    {'Content-Type' => 'application/json'}
  end

  def yt_embedify(text)
    # Turn youtube watch links into embed links
    return text.gsub(/watch\?v\=/, 'embed/').gsub(/m.youtube.com/, 'www.youtube.com')
  end

  def voat_get_api
    # Do a get from the voat api where the request matches a list of approved types
    voat_url = $voat_endpoints.select {|e| e['path'] == get_api_path}[0]['url']
    Unirest.get("#{$voat_api}#{voat_url}").body
  end
  
  private

  def api_request?
    # Is this a valid API request?
    request.path_info =~ /^\/api\/#{$api_version}\//
  end

  def get_api_path
    # Get the "path" the consumer is requesting from the API (strip the api and version from the request path)
    if api_request?
      return request.path_info.partition("/api/#{$api_version}/").last
    end
  end

  def filter_posts(limit: nil, start: nil, jsons: nil)
    # Get a limited number of objects from array
    if !limit
      jsons
    elsif !jsons
      return nil
    elsif start
      jsons[start..start+limit-1]
    end
  end

  def get_json
    # Get the json from the voat api 
    post_limit, post_start = nil
    jsons = load_cache_or_fetch.select {|p| p['MessageContent'] =~ /youtube\.com/}
    if request.params.include?('limit')
      post_limit = request.params['limit'].to_i
    end
    if request.params.include?('start')
      post_start = request.params['start'].to_i
    end
    posts = filter_posts(limit: post_limit, start: post_start, jsons: jsons)
    yt_embedify(posts.to_json)
  end

  def load_cache_or_fetch
    # Does get from api if cache not present
    cache_path = "/tmp/cache/voat-music/#{get_api_path}cache.json"
    return voat_get_api unless File.exist?(cache_path)
    cache_file = File.read(cache_path)
    JSON.parse(cache_file)
  end

  def save_cache
    # Saves json to file
    cache_path = "/tmp/cache/voat-music/#{get_api_path}cache.json"
    # Create the cache directory
    d = File.dirname(cache_path)
    unless File.directory?(d)
      FileUtils.mkdir_p(d)
    end
    # Open the cache file and save the json to it
    File.open(cache_path, "w") do |f|
      f.write(body)
    end
  end
end

class MyApp::Rack
  def call(env)
    request = Rack::Request.new(env)
    my_app = MyApp.new(request)
    [my_app.status, my_app.headers, [my_app.body]]
  end
end

use Rack::ContentType, "application/json"
use Rack::ContentLength
run MyApp::Rack.new
