class CreatePlaylistElements < ActiveRecord::Migration[5.0]
  def change
    create_table :playlist_elements, id: :uuid do |t|
      t.uuid :playlist_id, null: false
      t.uuid :item_id, null: false
      t.integer :position, null: false

      t.timestamps
    end
    add_index :playlist_elements, :playlist_id
    add_index :playlist_elements, :item_id
  end
end
