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

ActiveRecord::Schema[8.0].define(version: 2025_09_24_173757) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.date "date"
    t.float "value"
    t.boolean "ignore", default: false
    t.string "raw_description"
    t.string "description"
    t.string "comment"
    t.integer "statement_id", null: false
    t.integer "subcategory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statement_id"], name: "index_expenses_on_statement_id"
    t.index ["subcategory_id"], name: "index_expenses_on_subcategory_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

  create_table "statements", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.boolean "is_upload", default: false
    t.integer "source_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_statements_on_source_id"
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.string "access_token"
    t.datetime "access_token_expiry_date"
    t.boolean "access_token_enabled", default: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "expenses", "statements"
  add_foreign_key "expenses", "subcategories"
  add_foreign_key "sources", "users"
  add_foreign_key "statements", "sources"
  add_foreign_key "statements", "users"
  add_foreign_key "subcategories", "categories"
end
