class CreateMetaAbilities < ActiveRecord::Migration[5.1]
  def change
    create_table :abilities_meta_abilities, id: falase do |t|
      t.belongs_to :meta_ability,
                   index: true,
                   foreign_key: { on_delete: :cascade,
                                  on_update: :cascade }
      t.belongs_to :ability,
                   index: true,
                   foreign_key: { on_delete: :cascade,
                                  on_update: :cascade }
      t.timestamps
    end

    create_table :meta_abilities do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
