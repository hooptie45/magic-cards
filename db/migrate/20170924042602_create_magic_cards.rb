class CreateMagicCards < ActiveRecord::Migration[5.1]
  def change
    create_table :magic_cards do |t|
      t.belongs_to :magic_set,
                     index: true,
                     foreign_key: { on_delete: :cascade,
                                    on_update: :cascade }

      t.string :all_parts
      t.string :artist
      t.string :border_color
      t.string :card_faces
      t.string :cmc
      t.string :collector_number
      t.string :color_identity
      t.string :color_indicator
      t.string :colors
      t.string :colorshifted
      t.string :digital
      t.string :edhrec_rank
      t.string :flavor_text
      t.string :frame
      t.string :full_art
      t.string :futureshifted
      t.string :hand_modifier
      t.string :highres_image
      t.string :image_uris
      t.string :layout
      t.string :legalities
      t.string :life_modifier
      t.string :loyalty
      t.string :loyalty
      t.string :mana_cost
      t.string :mana_cost
      t.string :mtgo_id
      t.string :multiverse_ids, array: true
      t.string :name
      t.string :oracle_text
      t.string :power
      t.string :prints_search_uri
      t.string :rarity
      t.string :reprint
      t.string :reserved
      t.string :scryfall_id
      t.string :scryfall_set_uri
      t.string :scryfall_uri
      t.string :set
      t.string :set_setch_uri
      t.string :story_spotlight_number
      t.string :story_spotlight_uri
      t.string :timeshifted
      t.string :toughness
      t.string :type_line
      t.string :uri
      t.string :watermark

      t.timestamps
    end
  end
end
