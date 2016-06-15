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

ActiveRecord::Schema.define(version: 20160615122126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.decimal  "balance",    precision: 15, scale: 10, default: 0.0
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "accounts", ["owner_type", "owner_id"], name: "index_accounts_on_owner_type_and_owner_id", using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "iban"
    t.string   "name"
    t.string   "bic"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_number"
    t.string   "blz"
    t.string   "account_holder"
  end

  add_index "bank_accounts", ["user_id"], name: "index_bank_accounts_on_user_id", using: :btree

  create_table "conversation_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.string   "text"
    t.integer  "post_type"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.decimal  "amount",          precision: 15, scale: 10
    t.integer  "conversation_id"
  end

  add_index "conversation_posts", ["user_id"], name: "index_convesation_posts_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "text"
    t.integer  "post_type"
    t.decimal  "amount",     precision: 15, scale: 10
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "group_posts", ["group_id"], name: "index_group_posts_on_group_id", using: :btree
  add_index "group_posts", ["user_id"], name: "index_group_posts_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.decimal  "sum_per_person", precision: 15, scale: 10
  end

  add_index "groups", ["creator_id"], name: "index_groups_on_creator_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.decimal  "amount",      precision: 15, scale: 10
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.string   "text"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount",           precision: 15, scale: 10
    t.integer  "transaction_type"
    t.decimal  "balance_before",   precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "balance_after",    precision: 15, scale: 10
    t.string   "text"
    t.integer  "source_id"
    t.integer  "target_id"
  end

  add_index "transactions", ["source_id"], name: "index_transactions_on_source_id", using: :btree
  add_index "transactions", ["target_id"], name: "index_transactions_on_target_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "secret"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "authentication_token"
    t.string   "device_token"
    t.string   "encrypted_pin"
    t.boolean  "is_pin_verified",      default: false
    t.boolean  "is_phone_verified",    default: false
  end

  create_table "users_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
  end

  add_index "users_groups", ["group_id"], name: "index_users_groups_on_group_id", using: :btree
  add_index "users_groups", ["user_id"], name: "index_users_groups_on_user_id", using: :btree

  add_foreign_key "conversation_posts", "users"
  add_foreign_key "group_posts", "groups"
  add_foreign_key "group_posts", "users"
end
