class ChannelsController < ApplicationController
  before_action :set_channel, only: :show

  def index
    json_response Channel.all, each_serializer: ChannelShortSerializer
  end

  def show
    json_response @channel
  end
  
  private

  def set_channel
    @channel = Channel.find params[:id]
  end
end
