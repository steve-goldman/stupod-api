class Channel < ActiveRecord::Base
  has_many :items, dependent: :destroy
  validates_uniqueness_of :url
  validates_presence_of :url, :title
end
