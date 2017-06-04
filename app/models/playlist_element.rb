class PlaylistElement < ApplicationRecord
  validates_presence_of :playlist_id, :item_id
  belongs_to :playlist
  belongs_to :item
end
