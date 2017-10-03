# == Schema Information
#
# Table name: sales_prices
#
#  id                                   :integer          not null, primary key
#  purchasable_type                     :string
#  purchasable_id                       :integer
#  fair_price                           :decimal(8, 2)
#  buy_vendor_price                     :decimal(8, 2)
#  sell_vendor_price                    :decimal(8, 2)
#  sell_vendor                          :string
#  buy_vendor                           :string
#  quantity                             :integer          default(0)
#  count_for_trade                      :integer          default(0)
#  full_image_url                       :string
#  url                                  :string
#  absolute_change_since_yesterday      :float
#  absolute_change_since_one_week_ago   :float
#  percentage_change_since_yesterday    :float
#  percentage_change_since_one_week_ago :float
#  deleted_at                           :datetime
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class SalesPrice < ApplicationRecord
  belongs_to :purchasable, polymorphic: true
end
