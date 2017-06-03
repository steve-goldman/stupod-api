class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :destroy]
  before_action :set_playlists, only: :index

  def create
    @playlist = Playlist.create! playlist_params
    json_response @playlist, status: :created
  end

  def update
    @playlist.update! playlist_params
    head :no_content
  end

  def destroy
    @playlist.destroy!
    head :no_content
  end

  def index
    json_response @playlists
  end

  def show
    json_response @playlist
  end

  private

  def set_playlist
    @playlist = Playlist.find_by! user: current_user,
                                  id: params[:id]
  end

  def set_playlists
    @playlists = Playlist.find_by! user: current_user
  end

  def playlist_params
    params.permit(:name).merge(user: current_user)
  end
end
