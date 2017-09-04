class CreateSalesPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_prices do |t|
      t.references :purchasable, polymorphic: true, index: true

      t.money :fair_price

      t.string :best_vendor_buy
      t.money :best_vendor_buy_price
      t.money :lowest_price

      t.integer :quantity, default: 0
      t.integer :count_for_trade, default: 0

      t.string :full_image_url
      t.string :url

      t.string :absolute_change_since_yesterday,
               :absolute_change_since_one_week_ago,
               :percentage_change_since_yesterday,
               :percentage_change_since_one_week_ago

      t.datetime :deleted_at

      t.timestamps
    end
  end
end
