class PlaylistElement < ApplicationRecord
  validates_presence_of :playlist, :item, :position
  validates_numericality_of :position, only_integer: true
  belongs_to :playlist
  belongs_to :item
end
