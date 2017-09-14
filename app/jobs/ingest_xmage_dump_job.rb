require 'hashie'

class IngestXmageDumpJob < ApplicationJob

  def perform(pathname)
    Pathname(pathname).open do |f|
      json = JSON.load(f.read)
      json['rowsData'].each_with_index do |raw_hash, index|
        Card.transaction do
          hash = Hashie::Mash.new(raw_hash)

          card = Card.where(id: hash.id).first_or_create(
            name: hash.name,
            card_type: hash.type,
            card_sub_type: hash.subType,
            xmage_card_id: hash.id,
            power: hash.power,
            toughness:  hash.toughness,
            cost: hash.cost,
            raw_abilities: String(hash.abilities).split("$")
          )

          hash.editions.each do |edition|
            code = edition.expansionCode
            expansion = ExpansionSet.where(id: code).first_or_initialize
            expansion.name = edition.expansionName

            expansion.expansion_cards << ExpansionCard.new(rarity: edition.rarity,
                                                           card_number: edition.cardNumber,
                                                           card: card)
            expansion.save
          end

          card.derive_mana!
        end
      end
    end
  end
end

