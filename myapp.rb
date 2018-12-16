require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'rspotify'

configure :development, :test do
  require 'pry'
end

get '/' do
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  playlist_ids = params[:playlist_ids].split

  tracks = []
  playlist_ids.each do |playlist_id|
    playlist = RSpotify::Playlist.find(nil, playlist_id)
    tracks += playlist.tracks
  end
  tracks.flatten

  track_ids = tracks.map(&:id)
  duplicated_track_ids = track_ids.select { |id| track_ids.count(id) > 1 }

  track_id_counts = Hash.new(0)
  duplicated_track_ids.each { |track| track_id_counts[track] += 1 }
  sorted_track_id_counts = track_id_counts
                           .sort_by { |_key, value| value }
                           .reverse.to_h

  shared_tracks = tracks.select { |track| duplicated_track_ids.include?(track.id) }.uniq(&:id)
  @display_tracks = {}
  sorted_track_id_counts.each do |key, value|
    track = shared_tracks.detect { |shared_track| shared_track.id == key }
    @display_tracks["'#{track.name}' by #{track.artists.first.name}"] = value
  end
end
