class CreateSalesPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_prices do |t|
      t.references :purchasable, polymorphic: true, index: true

      t.decimal :fair_price,
                :buy_vendor_price,
                :sell_vendor_price,
                :precision => 8, :scale => 2

      t.string :sell_vendor
      t.string :buy_vendor

      t.integer :quantity, default: 0
      t.integer :count_for_trade, default: 0

      t.string :full_image_url
      t.string :url

      t.float :absolute_change_since_yesterday,
              :absolute_change_since_one_week_ago,
              :percentage_change_since_yesterday,
              :percentage_change_since_one_week_ago

      t.datetime :deleted_at

      t.timestamps
    end
  end
end
