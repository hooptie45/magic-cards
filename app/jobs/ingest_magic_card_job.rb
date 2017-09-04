require 'hashie'

class IngestMagicCardJob < ApplicationJob
  queue_as :default
  cattr_accessor :async_producer

  def perform(raw_card_json)
    hash = Hashie::Mash.new(raw_card_json).slice(*SalesPriceMapping.permitted_input_keys)
    if card = Card.where(name: hash.name).first
      attrs = SalesPriceMapping.new(hash).to_hash(symbolize: true)
      KAFKA_ASYNC.produce(JSON(attrs), topic: "card")

      card.sales_prices.create(attrs)
    end
  end
end
