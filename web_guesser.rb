require 'sinatra'
require 'sinatra/reloader'

number = rand(100)
success = "You got it!"
get '/' do

  erb :index, :locals => {:number => number}
end
