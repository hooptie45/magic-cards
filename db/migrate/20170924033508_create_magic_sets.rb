class CreateMagicSets < ActiveRecord::Migration[5.1]
  def change
    create_table :magic_sets do |t|
      t.string  :code
      t.string  :name
      t.string  :set_type
      t.date    :released_at
      t.string  :block_code
      t.string  :block
      t.string  :parent_set_code
      t.integer :card_count
      t.boolean :digital
      t.boolean :foil
      t.string  :icon_svg_uri
      t.string  :search_uri

      t.timestamps
    end
  end
end
