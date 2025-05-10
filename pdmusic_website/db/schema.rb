# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_03_07_111836) do
  create_table "action_text_rich_texts", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_logs", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", unsigned: true
    t.bigint "user_role_id", unsigned: true
    t.string "device"
    t.string "detected_ip", limit: 150
    t.string "action_name", limit: 150
    t.string "action_result", limit: 50
    t.string "component", limit: 150
    t.text "action_detail"
    t.datetime "action_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "additional_contents", charset: "utf8", force: :cascade do |t|
    t.string "title", limit: 250
    t.text "url"
    t.text "image"
    t.text "html_content"
    t.string "menu", limit: 100
    t.bigint "gallery_id"
    t.column "status", "enum('active','inactive','pre_delete','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", charset: "utf8", force: :cascade do |t|
    t.text "banner_image"
    t.string "menu_tag", limit: 150
    t.column "status", "enum('active','inactive','pre_delete','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cover_id"
  end

  create_table "categories", charset: "utf8", force: :cascade do |t|
    t.string "category_name", limit: 150
    t.text "description"
    t.column "status", "enum('active','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contents", charset: "utf8", force: :cascade do |t|
    t.string "title_content", limit: 250
    t.string "title_url", limit: 250
    t.text "url"
    t.text "image"
    t.text "content"
    t.integer "content_format", limit: 3
    t.string "menu", limit: 150
    t.bigint "categories_id"
    t.bigint "is_child_of"
    t.column "status", "enum('active','inactive','pre_delete','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "additional_content_id"
    t.json "table"
  end

  create_table "embeds", charset: "utf8", force: :cascade do |t|
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", charset: "utf8", force: :cascade do |t|
    t.string "menu_name", limit: 150
    t.string "menu_tag"
    t.text "icon"
    t.column "status", "enum('active','inactive','pre_delete','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "header", limit: 2
    t.integer "footer", limit: 2
  end

  create_table "menus_bk", charset: "utf8", force: :cascade do |t|
    t.string "menu_name", limit: 150
    t.text "icon"
    t.column "status", "enum('active','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", charset: "utf8", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "tabs", charset: "utf8", force: :cascade do |t|
    t.string "tab_name", limit: 150
    t.text "description"
    t.column "status", "enum('active','deleted')", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "username", limit: 250
    t.string "salt_password", limit: 250
    t.string "password", limit: 250
    t.string "firstname", limit: 250
    t.string "lastname", limit: 250
    t.column "status", "enum('active','inactive','deleted')", default: "active"
    t.integer "role", limit: 2
    t.string "email", limit: 250
    t.string "phone_number", limit: 20
    t.text "profile_pic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
