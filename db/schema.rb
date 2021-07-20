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

ActiveRecord::Schema.define(version: 20160413205641) do

  create_table "accounts", force: :cascade do |t|
    t.string   "netid",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: :cascade do |t|
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "preferred_name", limit: 255
    t.string   "unique_id",      limit: 255
    t.string   "email",          limit: 255
    t.string   "netid",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "department",     limit: 255
  end

  add_index "employees", ["unique_id"], name: "index_employees_on_unique_id", using: :btree

  create_table "mail_records", force: :cascade do |t|
    t.integer "waiver_info_id", limit: 4
    t.text    "blob",           limit: 65535
    t.string  "to",             limit: 255
    t.string  "cc",             limit: 255
    t.string  "bcc",            limit: 255
    t.string  "subject",        limit: 255
    t.text    "body",           limit: 65535
    t.string  "mime_type",      limit: 255
    t.string  "message_id",     limit: 255
    t.string  "date",           limit: 255
  end

  create_table "waiver_infos", force: :cascade do |t|
    t.string   "requester",         limit: 255
    t.string   "requester_email",   limit: 255
    t.string   "author_unique_id",  limit: 255
    t.string   "author_first_name", limit: 255
    t.string   "author_last_name",  limit: 255
    t.string   "author_status",     limit: 255
    t.string   "author_department", limit: 255
    t.string   "author_email",      limit: 255
    t.string   "title",             limit: 512
    t.string   "journal",           limit: 512
    t.string   "journal_issn",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes",             limit: 65535
  end

  add_index "waiver_infos", ["author_email"], name: "index_waiver_infos_on_author_email", using: :btree
  add_index "waiver_infos", ["requester_email"], name: "index_waiver_infos_on_requester_email", using: :btree

end
