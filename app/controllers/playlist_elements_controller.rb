class PlaylistElementsController < ApplicationController
  before_action :set_playlist
  before_action :set_playlist_element, except: [:index, :create]

  def create
    playlist_element = @playlist.playlist_elements.create! playlist_element_create_params
    json_response playlist_element, status: :created
  end

  def update
    @playlist_element.update! playlist_element_update_params
    head :no_content
  end

  def destroy
    @playlist_element.destroy!
    head :no_content
  end

  def index
    json_response @playlist.playlist_elements
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find params[:playlist_id]
  end

  def set_playlist_element
    @playlist_element = @playlist.playlist_elements.find params[:id]
  end

  def playlist_element_create_params
    params.permit :item_id, :position
  end

  def playlist_element_update_params
    params.permit :position
  end
end
