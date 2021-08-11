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

ActiveRecord::Schema.define(version: 2021_07_27_142554) do

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "netid"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "cas", null: false
    t.index ["provider"], name: "index_accounts_on_provider"
  end

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "preferred_name"
    t.string "unique_id"
    t.string "email"
    t.string "netid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "department"
    t.index ["unique_id"], name: "index_employees_on_unique_id"
  end

  create_table "mail_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "waiver_info_id"
    t.text "blob"
    t.string "to"
    t.string "cc"
    t.string "bcc"
    t.string "subject"
    t.text "body"
    t.string "mime_type"
    t.string "message_id"
    t.string "date"
    t.index ["waiver_info_id"], name: "index_mail_records_on_waiver_info_id"
  end

  create_table "waiver_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "requester"
    t.string "requester_email"
    t.string "author_unique_id"
    t.string "author_first_name"
    t.string "author_last_name"
    t.string "author_status"
    t.string "author_department"
    t.string "author_email"
    t.string "title", limit: 512
    t.string "journal", limit: 512
    t.string "journal_issn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["author_email"], name: "index_waiver_infos_on_author_email"
    t.index ["requester_email"], name: "index_waiver_infos_on_requester_email"
  end

end
