class Channel < ActiveRecord::Base
  has_many :items, dependent: :destroy
  validates_uniqueness_of :url
  validates_presence_of :url, :title

  def item_count
    items.count
  end

  def last_pub_date
    items.any? ? items.order(pubDate: :desc).first.pubDate : ''
  end
end
