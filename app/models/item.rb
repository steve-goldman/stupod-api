class Item < ActiveRecord::Base
  belongs_to :channel
  validates_uniqueness_of :guid
  validates_presence_of :channel, :guid, :url, :title
end
