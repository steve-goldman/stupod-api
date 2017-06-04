class Playlist < ApplicationRecord
  validates_presence_of :user, :name
  validates_uniqueness_of :name, scope: :user
end
