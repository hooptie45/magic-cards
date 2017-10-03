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

ActiveRecord::Schema.define(version: 20170924053553) do

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
    t.string "description"
    t.string "timing"
    t.string "rule"
    t.string "zone"
    t.string "ability_type"
    t.index ["sourceable_type", "sourceable_id"], name: "index_abilities_on_sourceable_type_and_sourceable_id"
  end

  create_table "abilities_cards", id: false, force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "ability_id", null: false
  end

  create_table "ability_cards", force: :cascade do |t|
    t.bigint "card_id"
    t.bigint "ability_id"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "mana", default: [], array: true
    t.json "costs", default: [], array: true
    t.string "rule"
    t.index ["ability_id"], name: "index_ability_cards_on_ability_id"
    t.index ["card_id"], name: "index_ability_cards_on_card_id"
  end

  create_table "ability_effects", force: :cascade do |t|
    t.json "metadata", default: {}
    t.bigint "ability_id"
    t.bigint "effect_id"
    t.index ["ability_id"], name: "index_ability_effects_on_ability_id"
    t.index ["effect_id"], name: "index_ability_effects_on_effect_id"
  end

  create_table "ability_types", force: :cascade do |t|
    t.bigint "ability_id"
    t.json "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_ability_types_on_ability_id"
  end

  create_table "card_symbols", force: :cascade do |t|
    t.string "symbol"
    t.string "loose_variant"
    t.string "english"
    t.boolean "transposable"
    t.boolean "represents_mana"
    t.boolean "appears_in_mana_costs"
    t.string "cmc"
    t.boolean "funny"
    t.string "colors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "mtg_card_id"
    t.string "xmage_card_id"
    t.string "color"
    t.string "cost"
    t.string "card_type"
    t.string "card_sub_type"
    t.integer "power"
    t.integer "toughness"
    t.string "raw_abilities", default: [], array: true
    t.boolean "xmage_implemeted"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xmage_name"
    t.index ["mtg_card_id"], name: "index_cards_on_mtg_card_id"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["power"], name: "index_cards_on_power"
    t.index ["toughness"], name: "index_cards_on_toughness"
    t.index ["xmage_card_id"], name: "index_cards_on_xmage_card_id"
  end

  create_table "catalog_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalogs", force: :cascade do |t|
    t.bigint "catalog_type_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_type_id"], name: "index_catalogs_on_catalog_type_id"
  end

  create_table "combos", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "effects", force: :cascade do |t|
    t.string "xmage_class"
    t.string "values"
    t.string "outcome"
    t.string "effect_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expansion_cards", force: :cascade do |t|
    t.string "expansion_set_id"
    t.bigint "card_id"
    t.string "rarity"
    t.integer "card_number"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_expansion_cards_on_card_id"
    t.index ["expansion_set_id", "card_number", "card_id"], name: "index_expansion_cards_on_card_number"
    t.index ["expansion_set_id"], name: "index_expansion_cards_on_expansion_set_id"
  end

  create_table "expansion_sets", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "name"], name: "index_expansion_sets_on_id_and_name", unique: true
  end

  create_table "magic_cards", force: :cascade do |t|
    t.string "scryfall_id"
    t.string "all_parts"
    t.string "artist"
    t.string "border_color"
    t.string "card_faces"
    t.string "cmc"
    t.string "collector_number"
    t.string "color_identity"
    t.string "color_indicator"
    t.string "colors"
    t.string "colorshifted"
    t.string "digital"
    t.string "edhrec_rank"
    t.string "flavor_text"
    t.string "frame"
    t.string "full_art"
    t.string "futureshifted"
    t.string "hand_modifier"
    t.string "highres_image"
    t.string "image_uris"
    t.string "layout"
    t.string "legalities"
    t.string "life_modifier"
    t.string "loyalty"
    t.string "mana_cost"
    t.string "mtgo_id"
    t.string "multiverse_ids"
    t.string "name"
    t.string "oracle_text"
    t.string "power"
    t.string "prints_search_uri"
    t.string "rarity"
    t.string "reprint"
    t.string "reserved"
    t.string "scryfall_set_uri"
    t.string "scryfall_uri"
    t.string "set"
    t.string "set_setch_uri"
    t.string "story_spotlight_number"
    t.string "story_spotlight_uri"
    t.string "timeshifted"
    t.string "toughness"
    t.string "type_line"
    t.string "uri"
    t.string "watermark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "magic_meta_data_catalogs", force: :cascade do |t|
    t.bigint "catalog_type_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_type_id"], name: "index_magic_meta_data_catalogs_on_catalog_type_id"
  end

  create_table "magic_sets", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "set_type"
    t.date "released_at"
    t.string "block_code"
    t.string "block"
    t.string "parent_set_code"
    t.integer "card_count"
    t.boolean "digital"
    t.boolean "foil"
    t.string "icon_svg_uri"
    t.string "search_uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mana_types", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.integer "cost", default: 1, null: false
  end

  create_table "manas", force: :cascade do |t|
    t.string "mana_type_id"
    t.string "mana_targetable_type"
    t.bigint "mana_targetable_id"
    t.index ["mana_targetable_type", "mana_targetable_id"], name: "index_manas_on_mana_targetable_type_and_mana_targetable_id"
    t.index ["mana_type_id"], name: "index_manas_on_mana_type_id"
  end

  create_table "meta_abilities", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meta_ability_cards", force: :cascade do |t|
    t.bigint "card_id"
    t.bigint "ability_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_meta_ability_cards_on_ability_id"
    t.index ["card_id"], name: "index_meta_ability_cards_on_card_id"
  end

  create_table "sales_prices", force: :cascade do |t|
    t.string "purchasable_type"
    t.bigint "purchasable_id"
    t.decimal "fair_price", precision: 8, scale: 2
    t.decimal "buy_vendor_price", precision: 8, scale: 2
    t.decimal "sell_vendor_price", precision: 8, scale: 2
    t.string "sell_vendor"
    t.string "buy_vendor"
    t.integer "quantity", default: 0
    t.integer "count_for_trade", default: 0
    t.string "full_image_url"
    t.string "url"
    t.float "absolute_change_since_yesterday"
    t.float "absolute_change_since_one_week_ago"
    t.float "percentage_change_since_yesterday"
    t.float "percentage_change_since_one_week_ago"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchasable_type", "purchasable_id"], name: "index_sales_prices_on_purchasable_type_and_purchasable_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "line"
    t.string "filename"
    t.string "git_sha"
    t.bigint "sourceable_id"
    t.string "sourceable_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sourceable_id", "sourceable_type"], name: "index_sources_on_sourceable_id_and_sourceable_type"
    t.index ["sourceable_type", "sourceable_id"], name: "index_sources_on_sourceable_type_and_sourceable_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "ability_cards", "abilities", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ability_cards", "cards", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ability_effects", "abilities", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ability_effects", "effects", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ability_types", "abilities", on_update: :cascade, on_delete: :cascade
  add_foreign_key "catalogs", "catalog_types"
  add_foreign_key "expansion_cards", "cards", on_update: :cascade, on_delete: :cascade
  add_foreign_key "expansion_cards", "expansion_sets", on_update: :cascade, on_delete: :cascade
  add_foreign_key "magic_meta_data_catalogs", "catalog_types"
  add_foreign_key "manas", "mana_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "meta_ability_cards", "abilities", on_update: :cascade, on_delete: :cascade
  add_foreign_key "meta_ability_cards", "cards", on_update: :cascade, on_delete: :cascade
end
