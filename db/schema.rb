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

ActiveRecord::Schema.define(version: 20150403110921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "auth_code"
    t.string   "access_token"
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.string   "carrier"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "authorizations_e911_contexts", force: :cascade do |t|
    t.integer  "authorization_id"
    t.integer  "e911_context_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "authorizations_e911_contexts", ["authorization_id"], name: "index_authorizations_e911_contexts_on_authorization_id", using: :btree
  add_index "authorizations_e911_contexts", ["e911_context_id"], name: "index_authorizations_e911_contexts_on_e911_context_id", using: :btree

  create_table "e911_contexts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "e911id"
    t.string   "name"
    t.string   "houseNumber"
    t.string   "houseNumExt"
    t.string   "streetDir"
    t.string   "streetDirSuffix"
    t.string   "street"
    t.string   "streetNameSuffix"
    t.string   "unit"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "addressAdditional"
    t.string   "comments"
    t.boolean  "isAddressConfirmed"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "e911_contexts", ["user_id"], name: "index_e911_contexts_on_user_id", using: :btree

  create_table "rtc_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "sessionId"
    t.datetime "started_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rtc_sessions", ["user_id"], name: "index_rtc_sessions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "authorizations", "users"
  add_foreign_key "authorizations_e911_contexts", "authorizations"
  add_foreign_key "authorizations_e911_contexts", "e911_contexts"
  add_foreign_key "e911_contexts", "users"
  add_foreign_key "rtc_sessions", "users"
end
