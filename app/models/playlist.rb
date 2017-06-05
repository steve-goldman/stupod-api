class Playlist < ApplicationRecord
  validates_presence_of :user, :name
  validates_uniqueness_of :name, scope: :user_id
  belongs_to :user
  has_many :playlist_elements, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
end
