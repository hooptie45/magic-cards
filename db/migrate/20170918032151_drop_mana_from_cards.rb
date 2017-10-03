class DropManaFromCards < ActiveRecord::Migration[5.1]
  def change
    remove_column(:cards, :mana)
  end
end
