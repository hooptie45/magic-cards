require 'hashie'

class SalesPriceMapping < Hashie::Trash
  property "purchasable_type", from: "purchasableType"
  property "purchasable_id", from: "purchasableId"
  property "fair_price"
  property "name"
  property "buy_vendor",       from: "bestVendorBuylist"
  property "buy_vendor_price", from: "bestVendorBuylistPrice"
  property "sell_vendor_price", from: "lowestPrice"
  property "sell_vendor", from: "lowestPriceVendor"
  property "quantity"
  property "count_for_trade", from: "countForTrade"
  property "full_image_url", from: "fullImageUrl"
  property "url"
  property "absolute_change_since_yesterday", from: "absoluteChangeSinceYesterday"
  property "absolute_change_since_one_week_ago", from: "absoluteChangeSinceOneWeekAgo"
  property "percentage_change_since_yesterday", from: "percentageChangeSinceYesterday"
  property "percentage_change_since_one_week_ago", from: "percentageChangeSinceOneWeekAgo"
end
