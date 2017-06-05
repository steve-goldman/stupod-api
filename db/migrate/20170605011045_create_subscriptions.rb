class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.uuid :playlist_id, null: false
      t.uuid :channel_id, null: false

      t.timestamps
    end
    add_index :subscriptions, :playlist_id
    add_index :subscriptions, :channel_id
    add_index :subscriptions, [:playlist_id, :channel_id], unique: true
  end
end
