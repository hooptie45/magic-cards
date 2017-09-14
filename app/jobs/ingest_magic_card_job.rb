require 'hashie'

class IngestMagicCardJob < ApplicationJob

  def perform(raw_card:, **kwargs)
    hash = Hashie::Mash.new(raw_card)
    hash = hash.slice(*SalesPriceMapping.permitted_input_keys)

    if card = Card.where(name: hash.name).first
      attrs = SalesPriceMapping.new(hash).to_hash(symbolize_keys: true)
      card.sales_prices.create(attrs.except(:name))
    end
  end
end
