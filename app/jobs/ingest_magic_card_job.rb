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
class IngestMagicCardJob < ApplicationJob
  queue_as :default

  def perform(raw_card_json)
    # Do something later
  end
end

