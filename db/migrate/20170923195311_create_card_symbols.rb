class CreateCardSymbols < ActiveRecord::Migration[5.1]
  def change
    create_table :card_symbols do |t|
      t.string :symbol
      t.string :loose_variant
      t.string :english
      t.boolean :transposable
      t.boolean :represents_mana
      t.boolean :appears_in_mana_costs
      t.string :cmc
      t.boolean :funny
      t.string :colors

      t.timestamps
    end
  end
end
