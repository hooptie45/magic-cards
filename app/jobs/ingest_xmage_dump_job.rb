require 'hashie'

# {
#     "cardId": "Submerged_BoneyardAether_RevoltfalseNM-M",
#     "name": "Submerged Boneyard",
#     "quantity": 0,
#     "countForTrade": 0,
#     "isFoil": false,
#     "url": "/sets/Aether_Revolt/Submerged_Boneyard",
#     "setUrl": "/spoiler_lists/Aether_Revolt",
#     "fair_price": 0.25,
#     "setName": "Aether Revolt",
#     "absoluteChangeSinceYesterday": -0.11000001430511475,
#     "absoluteChangeSinceOneWeekAgo": -0.12000000476837158,
#     "percentageChangeSinceYesterday": -30.555557250976562,
#     "percentageChangeSinceOneWeekAgo": -32.43243408203125,
#     "color": "Lnd",
#     "rarity": "C",
#     "manna": "",
#     "bestVendorBuylist": "Card Kingdom",
#     "bestVendorBuylistPrice": "0.06",
#     "lowestPrice": "0.25",
#     "lowestPriceVendor": "Card Kingdom",
#     "fullImageUrl": "http://s.mtgprice.com/sets/Aether_Revolt/img/Submerged Boneyard.full.jpg"
# }
#-------------------
# {
#      "id": 16952,
#      "name": "Territorial Hellkite",
#      "cost": "2$R$R",
#      "type": "Creature",
#      "subType": "Dragon",
#      "power": "6",
#      "toughness": "5",
#      "abilities": "Flying, haste$At the beginning of combat on your turn, choose an opponent at random that Territorial Hellkite didn't attack during your last combat. Territorial Hellkite attacks that player this combat if able. If you can't choose an opponent this way, tap Territorial Hellkite.",
#      "implemented": true,
#      "requested": false,
#      "tested": false,
#      "bugged": false,
#      "developer": null,
#      "editions": [
#        {
#          "rarity": "Rare",
#          "gathererId": "433270",
#          "mtgoImageId": null,
#          "expansionCode": "C17",
#          "expansionName": "Commander 2017",
#          "cardNumber": "29"
#        }
#      ],
#      "otherSide": null
#    },
# IngestXmageDumpJob.perform_now("./db/xmage_cards.json")
class IngestXmageDumpJob < ApplicationJob
  queue_as :default

  def perform(pathname)
    expansions_cache = {}
    Pathname(pathname).open do |f|
      json = JSON.load(f.read)

      json['rowsData'].each_with_index do |raw_hash, index|
        hash = Hashie::Mash.new(raw_hash)
        card = Card.create(
          name: hash.name,
          card_type: hash.type,
          card_sub_type: hash.subType,
          xmage_card_id: hash.id,
          power: hash.power,
          toughness:  hash.toughness,
          cost: hash.cost,
          abilities: String(hash.abilities).split("$")
        )

        card.expansion_cards = hash.editions.map {|edition|
          code = edition.expansionCode
          expansion = expansions_cache[code] || ExpansionSet.where(code: edition.expansionCode).first_or_create(name: edition.expansionName)
          ExpansionCard.new(expansion_set: expansion, rarity: edition.rarity, card_number: edition.cardNumber)
        }
        card.save
      end

      expansions_cache
    end
    # Do something later
  end
end

