class AddUserReferenceToPlaylists < ActiveRecord::Migration[5.0]
  def change
    remove_column :playlists, :user
    add_column :playlists, :user_id, :uuid, null: false
    add_index :playlists, [:user_id, :name], unique: true
  end
end
