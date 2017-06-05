class Channel < ActiveRecord::Base
  validates_uniqueness_of :url
  validates_presence_of :url, :title
  has_many :items, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def item_count
    items.count
  end

  def last_pub_date
    items.any? ? items.order(pubDate: :desc).first.pubDate : ''
  end
end
