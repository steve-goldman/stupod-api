class Item < ActiveRecord::Base
  validates_uniqueness_of :guid
  validates_presence_of :channel, :guid, :url, :title
  belongs_to :channel
  has_many :playlist_elements, dependent: :destroy
end
