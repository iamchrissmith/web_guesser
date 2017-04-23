require 'sinatra'
require 'sinatra/reloader'
require 'rack-livereload'

use Rack::LiveReload, :host => "localhost"

get '/' do
  "Hello, World!"
end
