class User < ActiveRecord::Base
  has_secure_password
  attr_accessor :password_digest
  validates_presence_of :token_id
  validates_uniqueness_of :token_id
  has_many :playlists, dependent: :destroy

  def self.from_token_payload payload
    user = User.find_by token_id: payload["sub"]
    if user.nil?
      password = SecureRandom.uuid
      user = User.create! token_id: payload["sub"],
                          password: password,
                          password_confirmation: password
    end
    user
  end
end
