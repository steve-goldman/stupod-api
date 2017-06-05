class SubscriptionsController < ApplicationController
  before_action :set_subscription, except: [:index, :create]
  before_action :set_playlist, only: [:create, :update]
  before_action :set_channel, only: :create

  def create
    subscription = @playlist.subscriptions.create! channel: @channel
    json_response subscription, status: :created
  end

  def update
    @subscription.update! playlist: @playlist
    head :no_content
  end

  def destroy
    @subscription.destroy!
    head :no_content
  end

  def index
    json_response current_user.subscriptions
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find params[:id]
  end

  def set_playlist
    @playlist = current_user.playlists.find params[:playlist_id]
  end

  def set_channel
    @channel = Channel.find params[:channel_id]
  end
end
