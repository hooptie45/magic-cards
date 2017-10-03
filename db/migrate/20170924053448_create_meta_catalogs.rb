class CreateMetaCatalogs < ActiveRecord::Migration[5.1]
  def change
    create_table :meta_catalog_types do |t|
      t.string :name

      t.timestamps
    end

    create_table :meta_catalogs do |t|
      t.belongs_to :meta_catalog_type, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
