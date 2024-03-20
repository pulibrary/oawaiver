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

ActiveRecord::Schema.define(version: 2021_07_27_142554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "netid"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "cas", null: false
    t.index ["provider"], name: "index_accounts_on_provider"
  end

  create_table "employees", force: :cascade do |t|
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

  create_table "mail_records", force: :cascade do |t|
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

  create_table "waiver_infos", force: :cascade do |t|
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
