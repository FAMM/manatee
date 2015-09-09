# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150830125331) do

  create_table "budgets", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", limit: 65535
    t.boolean  "single_user",               default: false
    t.string   "currency",    limit: 255,   default: "€"
    t.integer  "creator_id",  limit: 4,                     null: false
  end

  create_table "budgets_users", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "budget_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "planned",                precision: 20, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "budget_id",  limit: 4
    t.string   "color",      limit: 255
  end

  create_table "filter_conditions", force: :cascade do |t|
    t.string   "connector",  limit: 255
    t.string   "column",     limit: 255
    t.string   "operator",   limit: 255
    t.string   "value",      limit: 255
    t.integer  "filter_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount",                  precision: 20, scale: 2
    t.string   "comment",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "user_id",     limit: 4
    t.integer  "category_id", limit: 4
    t.integer  "budget_id",   limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language",               limit: 255, default: "en"
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
