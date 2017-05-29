class ChannelShortSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :image_url, :item_count, :last_pub_date
end
