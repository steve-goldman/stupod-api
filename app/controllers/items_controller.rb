class ItemsController < ApplicationController
  before_action :set_channel
  before_action :set_item, only: :show

  def index
    json_response @channel.items, each_serializer: ItemShortSerializer
  end

  def show
    json_response @item
  end
  
  private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def set_item
    @item = @channel.items.find_by!(id: params[:id]) if @channel
  end
end
