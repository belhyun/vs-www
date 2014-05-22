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

ActiveRecord::Schema.define(version: 20140520163023) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "issues", force: true do |t|
    t.string  "title"
    t.text    "description"
    t.date    "end_date"
    t.integer "stocks_count", default: 0
  end

  create_table "log_user_stocks", force: true do |t|
    t.integer  "type"
    t.integer  "stock_amounts"
    t.integer  "user_id"
    t.integer  "stock_id"
    t.integer  "issue_id"
    t.integer  "user_money"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_user_stocks", ["issue_id"], name: "index_log_user_stocks_on_issue_id", using: :btree
  add_index "log_user_stocks", ["stock_id"], name: "index_log_user_stocks_on_stock_id", using: :btree
  add_index "log_user_stocks", ["user_id"], name: "index_log_user_stocks_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_list_image"
  end

  add_index "photos", ["issue_id"], name: "index_photos_on_issue_id", using: :btree

  create_table "stocks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "money"
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["issue_id"], name: "index_stocks_on_issue_id", using: :btree

  create_table "user_stocks", force: true do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "issue_id"
    t.integer  "stock_amounts"
  end

  add_index "user_stocks", ["user_id"], name: "index_user_stocks_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "sns_id"
    t.string   "email"
    t.string   "uniq"
    t.string   "acc_token"
    t.datetime "expires"
    t.integer  "money"
    t.string   "nickname"
    t.string   "mem_type",           limit: 10
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
