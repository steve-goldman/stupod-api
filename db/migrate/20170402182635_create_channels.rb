class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels, id: :uuid do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.string :link
      t.string :language
      t.text :description
      t.string :image_url
      t.string :copyright
      t.string :author

      t.timestamps
    end
    add_index :channels, :url
  end
end
