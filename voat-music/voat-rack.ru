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
    {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s}
  end

  def body
    content = if homepage?
      "Your IP: #{request.ip}\nYour request was to #{request.path_info}"
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

  def get_json
    request.query_string
  end

  def layout(content)
%{<!DOCTYPE html>
<html lang="en">
  <head>

    <meta charset="utf-8">
    <title>Your IP</title>
  </head>
  <body>
    <h1>Rack server</h1>
    #{content}
  </body>
</html>}
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
