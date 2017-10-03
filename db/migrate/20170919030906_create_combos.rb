class CreateCombos < ActiveRecord::Migration[5.1]
  def change
    create_table :card_combos do |t|
      t.belongs_to :combo,
                   index: true,
                   foreign_key: { on_update: :cascade }

      t.belongs_to :card,
                   index: true,
                   foreign_key: { on_update: :cascade }

      t.string :description
      t.integer :next_card_id, :index => true
      t.integer :step, default: 0
      t.timestamps
    end if tables.include?("card_combos")
  end
end
