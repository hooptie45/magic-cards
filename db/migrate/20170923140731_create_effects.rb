class CreateEffects < ActiveRecord::Migration[5.1]
  def change
    create_table :effects do |t|
      t.string :xmage_class
      t.string :values
      t.string :outcome
      t.string :effect_type

      t.timestamps
    end

    change_table :abilities do |t|
      t.string :timing
      t.string :rule
      t.string :zone
      t.string :ability_type, :index => true
    end

    change_table :ability_cards do |t|
      # t.string :rule
      # t.string :zone
      # t.string :xmage_class, :index => true, :array => true, default: [], :index => true
    end

    create_table :ability_effects do |t|
      t.json :metadata, :default => {}
      t.belongs_to :ability,
                     index: true,
                     foreign_key: { on_delete: :cascade,
                                    on_update: :cascade }

      t.belongs_to :effect,
                     index: true,
                     foreign_key: { on_delete: :cascade,
                                    on_update: :cascade }
    end

    change_table :ability_cards do |t|
      t.json :mana, :array => true, :index => true, :default => []
      t.json :costs, :array => true, :index => true, :default => []
      t.string :rule
    end

    # Ability.delete_all

    Rake::Task["xmage:bulk_load_json"].execute
  end
end
