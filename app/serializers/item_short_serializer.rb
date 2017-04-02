class ItemShortSerializer < ActiveModel::Serializer
  attributes :id, :guid, :title, :pubDate
end
