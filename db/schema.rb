# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_05_160131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_labels", force: :cascade do |t|
    t.string "name"
    t.string "tid"
    t.bigint "legal_state_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["legal_state_id"], name: "index_bank_labels_on_legal_state_id"
  end

  create_table "deals", force: :cascade do |t|
    t.bigint "ecid"
    t.string "legal_state_dinamia"
    t.date "legal_state_date"
    t.bigint "total_amount"
    t.string "credit_entity"
    t.string "subsidy_entity"
    t.string "proyect_name"
    t.string "proyect_stage"
    t.string "proyect_apple"
    t.string "land_plot"
    t.bigint "mortgage_amount"
    t.string "city"
    t.bigint "subsidy_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "trello_flag"
    t.boolean "change_flag"
    t.bigint "legal_state_id", null: false
    t.index ["legal_state_id"], name: "index_deals_on_legal_state_id"
  end

  create_table "legal_states", force: :cascade do |t|
    t.string "name"
    t.string "board_tid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "list_tid"
  end

  create_table "subsidy_labels", force: :cascade do |t|
    t.string "name"
    t.string "tid"
    t.bigint "legal_state_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["legal_state_id"], name: "index_subsidy_labels_on_legal_state_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bank_labels", "legal_states"
  add_foreign_key "deals", "legal_states"
  add_foreign_key "subsidy_labels", "legal_states"
end
