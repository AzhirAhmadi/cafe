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

ActiveRecord::Schema.define(version: 2019_12_09_070629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_games", force: :cascade do |t|
    t.string "name", null: false
    t.string "publisher", null: false
    t.integer "min_player", null: false
    t.integer "max_player", null: false
    t.integer "play_time", null: false
    t.text "description"
    t.datetime "deleted_at"
    t.bigint "coffee_shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coffee_shop_id"], name: "index_board_games_on_coffee_shop_id"
    t.index ["name", "coffee_shop_id"], name: "index_board_games_on_name_and_coffee_shop_id", unique: true
  end

  create_table "coffee_shops", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.bigint "owner_id", null: false
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "maintainer_id", null: false
    t.index ["creator_id"], name: "index_coffee_shops_on_creator_id"
    t.index ["maintainer_id"], name: "index_coffee_shops_on_maintainer_id"
    t.index ["owner_id"], name: "index_coffee_shops_on_owner_id"
  end

  create_table "enrolments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "table_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_enrolments_on_table_id"
    t.index ["user_id", "table_id", "deleted_at"], name: "index_enrolments_on_user_id_and_table_id_and_deleted_at", unique: true
    t.index ["user_id"], name: "index_enrolments_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "deleted_at"
    t.bigint "coffee_shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "opens_at", null: false
    t.datetime "enrol_start_time", null: false
    t.datetime "enrol_end_time", null: false
    t.datetime "event_start_time", null: false
    t.datetime "event_end_time", null: false
    t.datetime "closed_at", null: false
    t.index ["coffee_shop_id"], name: "index_events_on_coffee_shop_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "image"
    t.string "parent_type"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_type", "parent_id"], name: "index_images_on_parent_type_and_parent_id"
  end

  create_table "tables", force: :cascade do |t|
    t.string "table_code", null: false
    t.datetime "deleted_at"
    t.bigint "event_id"
    t.bigint "board_game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capacity"
    t.integer "enroled", default: 0
    t.index ["board_game_id"], name: "index_tables_on_board_game_id"
    t.index ["event_id"], name: "index_tables_on_event_id"
    t.index ["table_code", "event_id"], name: "index_tables_on_table_code_and_event_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.integer "role"
    t.datetime "deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "board_games", "coffee_shops"
  add_foreign_key "coffee_shops", "users", column: "creator_id"
  add_foreign_key "coffee_shops", "users", column: "maintainer_id"
  add_foreign_key "coffee_shops", "users", column: "owner_id"
  add_foreign_key "enrolments", "tables"
  add_foreign_key "enrolments", "users"
  add_foreign_key "events", "coffee_shops"
  add_foreign_key "tables", "board_games"
  add_foreign_key "tables", "events"
end
