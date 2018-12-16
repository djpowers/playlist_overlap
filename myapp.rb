require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'rspotify'

configure :development, :test do
  require 'pry'
end

get '/' do
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
end
