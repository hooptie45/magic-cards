class CreateCards < ActiveRecord::Migration[5.1]
  def change
    ApplicationRecord.transaction do

      create_table :sources do |t|
        t.string :name
        t.string :line
        t.string :filename
        t.string :git_sha
        t.string :sourceable_id
        t.string :sourceable_type
        t.datetime :deleted_at
        t.index [:sourceable_id, :sourceable_type]
        t.timestamps
      end

      create_table :expansion_sets do |t|
        t.string :code,
                 :name,
                 :null => false
        t.datetime :deleted_at
        t.index [:code, :name], :unique => true
        t.timestamps
      end

      create_table :cards do |t|
        t.string :name, :index => true
        t.string :mtg_card_id, :index => true
        t.string :xmage_card_id, :index => true
        t.string :color
        t.string :cost
        t.string :mana, array: true, default: []
        t.string :type
        t.string :sub_type
        t.integer :power, :index => true
        t.integer :toughness, :index => true
        t.string :abilities, array: true, default: []
        t.boolean :xmage_implemeted

        t.references :sourceable, polymorphic: true, index: true

        t.datetime :deleted_at
        t.timestamps
      end

      create_table :expansion_cards do |t|
        t.belongs_to :expansion_set, foreign_key: true, index: true
        t.belongs_to :card, foreign_key: true, index: true
        t.string :rarity
        t.string :card_number
        t.datetime :deleted_at
        t.timestamps
      end

      create_table :abilities do |t|
        t.string :name
        t.string :type
        t.string :classification
        t.json :metadata, :default => "{}"
        t.references :sourceable, polymorphic: true, index: true
        t.datetime :deleted_at
        t.timestamps
      end

      create_table :card_abilities do |t|
        t.belongs_to :ability, foreign_key: true, index: true
        t.belongs_to :card, foreign_key: true, index: true
        t.json :metadata
        t.datetime :deleted_at
        t.timestamps
      end

    end
  end
end
