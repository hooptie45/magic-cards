class AddXmageNameToCards < ActiveRecord::Migration[5.1]
  def change
    change_table(:cards) do |t|
      t.column(:xmage_name, :string)
    end
    Card.find_each do |c|
      c.xmage_name = c.name.scan(/[A-Za-z]+\s?/).map(&:strip).map(&:classify).join("")
      c.save
    end
  end
end
