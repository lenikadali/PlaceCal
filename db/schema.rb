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

ActiveRecord::Schema.define(version: 20170726032515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street_address"
    t.string "street_address2"
    t.string "street_address3"
    t.string "city"
    t.string "postcode"
    t.string "country_code",    default: "UK"
    t.float  "latitude"
    t.float  "longitude"
  end

  create_table "calendars", force: :cascade do |t|
    t.string   "name"
    t.string   "source"
    t.string   "type"
    t.datetime "last_import_at"
    t.integer  "partner_id"
    t.integer  "place_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["partner_id"], name: "index_calendars_on_partner_id", using: :btree
    t.index ["place_id"], name: "index_calendars_on_place_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "place_id"
    t.string   "uid"
    t.datetime "dtstart"
    t.datetime "dtend"
    t.text     "summary"
    t.text     "description"
    t.text     "location"
    t.text     "rrule"
    t.boolean  "is_active",   default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["place_id"], name: "index_events_on_place_id", using: :btree
  end

  create_table "events_partners", force: :cascade do |t|
    t.integer "event_id"
    t.integer "partner_id"
    t.index ["event_id"], name: "index_events_partners_on_event_id", using: :btree
    t.index ["partner_id"], name: "index_events_partners_on_partner_id", using: :btree
  end

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.string   "logo"
    t.string   "public_phone"
    t.string   "public_email"
    t.string   "admin_name"
    t.string   "admin_email"
    t.text     "short_description"
    t.integer  "address_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["address_id"], name: "index_partners_on_address_id", using: :btree
  end

  create_table "partners_places", force: :cascade do |t|
    t.integer "partner_id"
    t.integer "place_id"
    t.index ["partner_id"], name: "index_partners_places_on_partner_id", using: :btree
    t.index ["place_id"], name: "index_partners_places_on_place_id", using: :btree
  end

  create_table "partners_users", force: :cascade do |t|
    t.integer "partner_id"
    t.integer "user_id"
    t.index ["partner_id"], name: "index_partners_users_on_partner_id", using: :btree
    t.index ["user_id"], name: "index_partners_users_on_user_id", using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "status"
    t.string   "logo"
    t.jsonb    "opening_times"
    t.text     "short_description"
    t.text     "booking_info"
    t.text     "accessibility_info"
    t.integer  "address_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["address_id"], name: "index_places_on_address_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.string   "phone"
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "calendars", "partners"
  add_foreign_key "calendars", "places"
  add_foreign_key "events", "places"
  add_foreign_key "events_partners", "events"
  add_foreign_key "events_partners", "partners"
  add_foreign_key "partners", "addresses"
  add_foreign_key "partners_places", "partners"
  add_foreign_key "partners_places", "places"
  add_foreign_key "partners_users", "partners"
  add_foreign_key "partners_users", "users"
  add_foreign_key "places", "addresses"
end
