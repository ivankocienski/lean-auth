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

ActiveRecord::Schema.define(version: 20150810112314) do

  create_table "emotions", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "log_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "analyzed",   default: false
  end

  create_table "log_entry_emotions", force: :cascade do |t|
    t.integer  "log_entry_id"
    t.integer  "emotion_id"
    t.float    "percentage"
    t.integer  "count"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "mood_day_emotions", force: :cascade do |t|
    t.integer  "mood_day_id"
    t.integer  "emotion_id"
    t.float    "percentage"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "mood_days", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "day_in_time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                   default: ""
    t.string   "password_encoded",        default: ""
    t.string   "password_salt",           default: ""
    t.string   "display_name",            default: ""
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "forgot_password_token"
    t.datetime "forgot_password_expires"
  end

end
