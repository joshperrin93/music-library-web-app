# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    binding.irb
    return erb(:album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    binding.irb
    return erb(:artist)
  end

  get '/artists/new' do
    binding.irb
    return erb(:new_artist)
  end

  get '/albums/new' do
    binding.irb
    return erb(:new_album)
  end

  post '/albums' do
    binding.irb
    if validate_album_params?
      status 400
      return ''
    end
    binding.irb
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    binding.irb
    return erb(:album_created)
  end

  post '/artists' do
    binding.irb
    if validate_artist_params?
      status 400
      return ''
    end
    binding.irb
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
    binding.irb
    return erb(:artist_created)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    binding.irb
    return erb(:album_id)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    binding.irb
    return erb(:artist_id)
  end

  private

  def validate_album_params?
    binding.irb
    return params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
  end

  def validate_artist_params?
    binding.irb
    return params[:name] == nil || params[:genre] == nil
  end
end