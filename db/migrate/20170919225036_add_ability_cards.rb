class AddAbilityCards < ActiveRecord::Migration[5.1]
  def change
    create_table :ability_cards do |t|
      t.belongs_to :card,
                   index: true,
                   foreign_key: { on_delete: :cascade,
                                  on_update: :cascade }
      t.belongs_to :ability,
                   index: true,
                   foreign_key: { on_delete: :cascade,
                                  on_update: :cascade }
      t.json :metadata
      t.timestamps
    end
  end
end
