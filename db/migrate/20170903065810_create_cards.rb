class CreateCards < ActiveRecord::Migration[5.1]
  def change
    ApplicationRecord.transaction do

      create_table :sources do |t|
        t.string :name
        t.string :line
        t.string :filename
        t.string :git_sha
        t.integer :sourceable_id
        t.string :sourceable_type
        t.datetime :deleted_at
        t.references :sourceable, polymorphic: true, index: true
        t.index [:sourceable_id, :sourceable_type]
        t.timestamps
      end

      create_table :mana_types, id: :string do |t|
        t.string :name, :null => false
        t.integer :cost, :default => 1, :null => false
      end

      create_table :manas do |t|
        t.string :mana_type_id, index: true
        t.foreign_key :mana_types, on_delete: :cascade, on_update: :cascade
        t.references :mana_targetable, polymorphic: true, index: true
      end

      create_table :cards, :id => :integer do |t|
        t.string :name, :index => true
        t.string :mtg_card_id, :index => true
        t.string :xmage_card_id, :index => true
        t.string :color
        t.string :cost
        t.string :card_type
        t.string :card_sub_type
        t.integer :power, :index => true
        t.integer :toughness, :index => true
        t.string :raw_abilities, array: true, default: []
        t.boolean :xmage_implemeted

        t.datetime :deleted_at
        t.timestamps
      end

      create_table :expansion_sets, :id => :string do |t|
        t.string :name, :null => false
        t.datetime :deleted_at
        t.index [:id, :name], :unique => true
        t.timestamps
      end

      create_table :expansion_cards do |t|
        t.string :expansion_set_id, index: true
        t.foreign_key :expansion_sets, on_delete: :cascade, on_update: :cascade
        t.belongs_to :card,
                     index: true,
                     foreign_key: { on_delete: :cascade,
                                    on_update: :cascade }

        t.string :rarity
        t.integer :card_number
        t.datetime :deleted_at
        t.index [:expansion_set_id, :card_number, :card_id], :name => :index_expansion_cards_on_card_number
        t.timestamps
      end

      create_table :abilities do |t|
        t.string :name
        t.string :type
        t.string :classification
        t.json :metadata, :default => "{}"
        t.references :sourceable, polymorphic: true, index: true
        t.references :targetable, polymorphic: true, index: true
        t.datetime :deleted_at
        t.timestamps
      end

      create_table :ability_types do |t|
        t.belongs_to :ability,
                     index: true,
                     foreign_key: { on_delete: :cascade,
                                    on_update: :cascade }
        t.json :metadata
        t.datetime :deleted_at
        t.timestamps
      end

      ManaType.setup!

    end
  end
end
