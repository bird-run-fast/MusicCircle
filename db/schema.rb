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

ActiveRecord::Schema.define(version: 2020_08_26_092411) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "enduser_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enduser_id"], name: "index_comments_on_enduser_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "concerns", force: :cascade do |t|
    t.integer "enduser_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "endusers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "area"
    t.integer "age"
    t.text "introduction"
    t.string "image_id"
    t.float "score"
    t.boolean "is_deleted", default: false, null: false
    t.index ["email"], name: "index_endusers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_endusers_on_reset_password_token", unique: true
  end

  create_table "entries", force: :cascade do |t|
    t.integer "enduser_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enduser_id"], name: "index_entries_on_enduser_id"
    t.index ["room_id"], name: "index_entries_on_room_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "enduser_id"
    t.integer "room_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enduser_id"], name: "index_messages_on_enduser_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "post_id"
    t.integer "comment_id"
    t.integer "message_id"
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["message_id"], name: "index_notifications_on_message_id"
    t.index ["post_id"], name: "index_notifications_on_post_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.integer "post_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "enduser_id"
    t.string "title"
    t.text "body"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tw_related_words", force: :cascade do |t|
    t.string "name"
    t.float "salience"
    t.boolean "latest", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tw_sentiments", force: :cascade do |t|
    t.float "score"
    t.integer "tw_count"
    t.boolean "latest", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
