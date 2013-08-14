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

ActiveRecord::Schema.define(version: 20130729042809) do

  create_table "games", force: true do |t|
    t.integer  "max_rounds", null: false
    t.integer  "last_round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.integer  "game_id",      null: false
    t.integer  "round_number", null: false
    t.string   "weather",      null: false
    t.string   "crop_choice",  null: false
    t.datetime "created_at"
  end

  add_index "rounds", ["game_id", "round_number"], name: "index_rounds_on_game_id_and_round_number", unique: true

end
