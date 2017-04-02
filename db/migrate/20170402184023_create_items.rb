class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items, id: :uuid do |t|
      t.uuid :channel_id, null: false
      t.string :guid, null: false
      t.string :url, null: false
      t.integer :length
      t.string :file_type
      t.string :title, null: false
      t.datetime :pubDate
      t.string :link
      t.text :description
      t.string :author
      t.string :duration

      t.timestamps
    end
    add_index :items, :channel_id
    add_index :items, :guid
  end
end
