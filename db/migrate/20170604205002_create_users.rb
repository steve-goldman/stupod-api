class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :token_id, null: false

      t.timestamps
    end
    add_index :users, :token_id
  end
end
