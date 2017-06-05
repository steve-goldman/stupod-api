# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170605011045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "channels", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "url",         null: false
    t.string   "title",       null: false
    t.string   "link"
    t.string   "language"
    t.text     "description"
    t.string   "image_url"
    t.string   "copyright"
    t.string   "author"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["url"], name: "index_channels_on_url", using: :btree
  end

  create_table "items", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "channel_id",  null: false
    t.string   "guid",        null: false
    t.string   "url",         null: false
    t.integer  "length"
    t.string   "file_type"
    t.string   "title",       null: false
    t.datetime "pubDate"
    t.string   "link"
    t.text     "description"
    t.string   "author"
    t.string   "duration"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["channel_id"], name: "index_items_on_channel_id", using: :btree
    t.index ["guid"], name: "index_items_on_guid", using: :btree
  end

  create_table "playlist_elements", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "playlist_id", null: false
    t.uuid     "item_id",     null: false
    t.integer  "position",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["item_id"], name: "index_playlist_elements_on_item_id", using: :btree
    t.index ["playlist_id"], name: "index_playlist_elements_on_playlist_id", using: :btree
  end

  create_table "playlists", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid     "user_id",    null: false
    t.index ["user_id", "name"], name: "index_playlists_on_user_id_and_name", unique: true, using: :btree
  end

  create_table "subscriptions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "playlist_id", null: false
    t.uuid     "channel_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["channel_id"], name: "index_subscriptions_on_channel_id", using: :btree
    t.index ["playlist_id", "channel_id"], name: "index_subscriptions_on_playlist_id_and_channel_id", unique: true, using: :btree
    t.index ["playlist_id"], name: "index_subscriptions_on_playlist_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "token_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token_id"], name: "index_users_on_token_id", using: :btree
  end

end
