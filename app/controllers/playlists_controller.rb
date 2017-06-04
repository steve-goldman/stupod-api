class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :destroy]

  def create
    playlist = current_user.playlists.create! playlist_params
    json_response playlist, status: :created
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
    json_response current_user.playlists
  end

  def show
    json_response @playlist
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find params[:id]
  end

  def playlist_params
    params.permit :name
  end
end
