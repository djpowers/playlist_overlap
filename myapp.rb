require 'sinatra'
require 'sinatra/reloader'

configure :development, :test do
  require 'pry'
end

get '/' do
  'Hello world!'
end
