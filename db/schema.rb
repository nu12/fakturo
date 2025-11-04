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

ActiveRecord::Schema[8.1].define(version: 2025_09_24_173757) do
  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "description"
    t.boolean "ignore", default: false
    t.string "raw_description"
    t.integer "statement_id", null: false
    t.integer "subcategory_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.float "value"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["statement_id"], name: "index_expenses_on_statement_id"
    t.index ["subcategory_id"], name: "index_expenses_on_subcategory_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

  create_table "statements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.boolean "is_upload", default: false
    t.integer "month"
    t.integer "source_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "year"
    t.index ["source_id"], name: "index_statements_on_source_id"
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
    t.index ["user_id"], name: "index_subcategories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "access_token"
    t.boolean "access_token_enabled", default: false
    t.datetime "access_token_expiry_date"
    t.datetime "created_at", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "uuid"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "statements"
  add_foreign_key "expenses", "subcategories"
  add_foreign_key "expenses", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "sources", "users"
  add_foreign_key "statements", "sources"
  add_foreign_key "statements", "users"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "subcategories", "users"
end
