class ChannelsController < ApplicationController
  before_action :set_channel, only: :show

  def create
    channel = Channel.find_by url: params[:url]
    if channel.nil?
      begin
        channel = ChannelLoader.new.load params[:url]
        json_response channel, status: :created
      rescue
        render json: { message: "Unable to load channel" }, status: :unprocessable_entity
      end
    else
      json_response channel, status: :created
    end
  end

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
