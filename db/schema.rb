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

ActiveRecord::Schema[8.0].define(version: 2025_07_02_224349) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "adoptions", force: :cascade do |t|
    t.bigint "pet_id", null: false
    t.bigint "applicant_id", null: false
    t.bigint "owner_id", null: false
    t.string "status"
    t.text "message"
    t.text "owner_notes"
    t.datetime "application_date"
    t.datetime "response_date"
    t.datetime "completion_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_adoptions_on_applicant_id"
    t.index ["owner_id"], name: "index_adoptions_on_owner_id"
    t.index ["pet_id"], name: "index_adoptions_on_pet_id"
  end

  create_table "pets", force: :cascade do |t|
    t.string "name"
    t.string "species"
    t.string "breed"
    t.string "size"
    t.integer "age"
    t.string "gender"
    t.string "description"
    t.string "images", default: [], array: true
    t.string "vaccinations", default: [], array: true
    t.string "status"
    t.boolean "isNeutered"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipCode"
    t.string "avatar"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "adoptions", "pets"
  add_foreign_key "adoptions", "users", column: "applicant_id"
  add_foreign_key "adoptions", "users", column: "owner_id"
end
