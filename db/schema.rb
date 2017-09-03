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

ActiveRecord::Schema.define(version: 20170903065810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "classification"
    t.json "metadata", default: "{}"
    t.string "sourceable_type"
    t.bigint "sourceable_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sourceable_type", "sourceable_id"], name: "index_abilities_on_sourceable_type_and_sourceable_id"
  end

  create_table "card_abilities", force: :cascade do |t|
    t.bigint "ability_id"
    t.bigint "card_id"
    t.json "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_card_abilities_on_ability_id"
    t.index ["card_id"], name: "index_card_abilities_on_card_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.string "mtg_card_id"
    t.string "xmage_card_id"
    t.string "color"
    t.string "cost"
    t.string "mana", default: [], array: true
    t.string "type"
    t.string "sub_type"
    t.integer "power"
    t.integer "toughness"
    t.string "abilities", default: [], array: true
    t.boolean "xmage_implemeted"
    t.string "sourceable_type"
    t.bigint "sourceable_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mtg_card_id"], name: "index_cards_on_mtg_card_id"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["power"], name: "index_cards_on_power"
    t.index ["sourceable_type", "sourceable_id"], name: "index_cards_on_sourceable_type_and_sourceable_id"
    t.index ["toughness"], name: "index_cards_on_toughness"
    t.index ["xmage_card_id"], name: "index_cards_on_xmage_card_id"
  end

  create_table "expansion_cards", force: :cascade do |t|
    t.bigint "expansion_set_id"
    t.bigint "card_id"
    t.string "rarity"
    t.string "card_number"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_expansion_cards_on_card_id"
    t.index ["expansion_set_id"], name: "index_expansion_cards_on_expansion_set_id"
  end

  create_table "expansion_sets", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code", "name"], name: "index_expansion_sets_on_code_and_name", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "line"
    t.string "filename"
    t.string "git_sha"
    t.string "sourceable_id"
    t.string "sourceable_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sourceable_id", "sourceable_type"], name: "index_sources_on_sourceable_id_and_sourceable_type"
  end

  add_foreign_key "card_abilities", "abilities"
  add_foreign_key "card_abilities", "cards"
  add_foreign_key "expansion_cards", "cards"
  add_foreign_key "expansion_cards", "expansion_sets"
end
