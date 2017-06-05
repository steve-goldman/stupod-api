class PlaylistElement < ApplicationRecord
  validates_presence_of :playlist, :item
  belongs_to :playlist
  belongs_to :item
end
