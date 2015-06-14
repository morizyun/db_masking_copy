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

ActiveRecord::Schema.define(version: 20150613051328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mask_settings", force: :cascade, comment: "Manage settings for masking data" do |t|
    t.string   "db_key",      null: false, comment: "key name in db/config/database.yml"
    t.string   "table",       null: false, comment: "table name"
    t.string   "column",      null: false, comment: "column name"
    t.string   "mask_type",   null: false, comment: "type of masking"
    t.text     "fixed_value",              comment: "fixed value to fill column value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "mask_settings", ["db_key", "table", "column"], name: "index_mask_settings_on_db_key_and_table_and_column", unique: true, using: :btree

end
