class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists, id: :uuid do |t|
      t.string :user, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :playlists, [:user, :name], unique: true
  end
end
