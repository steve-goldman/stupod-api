class Subscription < ApplicationRecord
  validates_presence_of :playlist, :channel
  validates_uniqueness_of :channel, scope: :playlist_id
  belongs_to :playlist
  belongs_to :channel
end
