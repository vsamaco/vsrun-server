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

ActiveRecord::Schema.define(version: 2021_10_25_214958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "name"
    t.string "activity_type"
    t.datetime "start_date"
    t.json "laps"
    t.json "splits"
    t.json "map"
    t.decimal "distance"
    t.decimal "moving_time"
    t.decimal "elapsed_time"
    t.decimal "total_elevation_gain"
    t.decimal "start_latitude"
    t.decimal "start_longitude"
    t.string "start_latlong"
    t.decimal "end_latitude"
    t.decimal "end_longitude"
    t.string "end_latlong"
    t.string "external_gear_id"
    t.string "external_athlete_id"
    t.bigint "athlete_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["athlete_id"], name: "index_activities_on_athlete_id"
  end

  create_table "athletes", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.json "shoes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["external_id"], name: "index_athletes_on_external_id", unique: true
    t.index ["user_id"], name: "index_athletes_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "expired_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "athletes"
  add_foreign_key "athletes", "users"
end
