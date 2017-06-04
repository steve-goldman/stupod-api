class Playlist < ApplicationRecord
  validates_presence_of :user_id, :name
  validates_uniqueness_of :name, scope: :user_id
  belongs_to :user
end
