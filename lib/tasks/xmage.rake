namespace :xmage do
  XMAGE_REPO_PATH          = Rails.root.join("tmp/xmage")
  XMAGE_ABILITIES_PATH     = Rails.root.join("data/abilities.txt")
  XMAGE_ABILITY_TYPES_PATH = Rails.root.join("data/ability-types.txt")
  XMAGE_JSON_ABILITY_DUMP_PATH  = Rails.root.join("data/xmage-abilities.json")
  XMAGE_ABILITY_DUMP_PATH  = Rails.root.join("data/xmage-dump.yml")

  MODELS_PATH = Rails.root.join("app", "models")
  ABILITY_MODELS_PATH = MODELS_PATH.join("abilities")
  ABILITIES_LINE_REGEX = /(\w)\/(\w+).java:(\d+):\s?import mage\.(.*)\.(\w+);$/

  desc "clone xmage repo"
  task :clone do |t, args|
    unless XMAGE_REPO_PATH.exist?
      url = ENV.fetch("XMAGE_REPO_URL", "https://github.com/magefree/mage.git")
      sh("git clone --depth 1 #{url} #{XMAGE_REPO_PATH}") #
    end
  end

  desc "remove xmage repo"
  task :clean do |t, args|
    path = Pathname(XMAGE_REPO_PATH)
    path.rmtree if path.exist?
  end


  desc "add abilities"
  task :add_abilities => [:environment] do |t, args|
    hash = Hash.new {|h,k| h[k] = [] }
    XMAGE_ABILITIES_PATH.open do |f|
      f.each_with_index do |line, index|

        if line =~ ABILITIES_LINE_REGEX
          # 1.	u                  #
          # 2.	UlamogsNullifier   #
          # 3.	37                 #
          # 4.	abilities.keyword  #
          # 5.	FlyingAbility      #
          letter = $1
          xmage_card_name = [$2]
          xmage_card_name |= [xmage_card_name.first.underscore.split("_").map(&:classify).join("")]
          line = $3.to_s
          package = $4
          ability_name = $5
          next if ability_name == "Ability" ||
                  ability_name == "Effect" ||
                  ability_name == "SimpleActivatedAbility" ||
                  ability_name == "ManaCostsImpl"

          full_ability_name = [$4, ability_name].join(".")

          ruby_ability_class = full_ability_name.split(".").map(&:camelize).join("::")
          hash[full_ability_name] |= xmage_card_name
        end
      end
    end

    AbilityCard.bulk_insert do |worker|
      hash.each do |full_ability_name, card_names|
        ability = Ability.where(name: full_ability_name).first_or_create
        Card.where(xmage_name: card_names).find_each do |card|
          worker.add(ability_id: ability.id, card_id: card.id)
        end
      end
    end


    ActsAsTaggableOn::Tagging.bulk_insert do |tagging|
    end
  end

  # {"cardNumber"=>"105",
  #   "name"=>"Icy Blast",
  #   "mana"=>{"color"=>"{X}{U}", "cost"=>1},
  #   "type"=>["Instant"],
  #   "abilities"=>
  #    [{"timing"=>"INSTANT",
  #      "costs"=>[],
  #      "zone"=>"HAND",
  #      "effects"=>
  #       [{"values"=>nil,
  #         "duration"=>nil,
  #         "outcome"=>"Tap",
  #         "type"=>"One Shot Effect",
  #         "class"=>"class mage.abilities.effects.common.TapTargetEffect"},
  #        {"values"=>nil,
  #         "duration"=>"",
  #         "outcome"=>"Detriment",
  #         "type"=>"Layered rule modification",
  #         "class"=>
  #          "class mage.abilities.decorator.ConditionalContinuousRuleModifyingEffect"}],
  #      "mana"=>[{"color"=>"{X}", "cost"=>0}, {"color"=>"{U}", "cost"=>1}],
  #      "type"=>"Spell",
  #      "rule"=>
  #       "tap X target creatures. <br/><i>Ferocious</i> &mdash; If you control a creature with power 4 or greater, those creatures don't untap during their controllers' next untap steps."}],
  #   "expansion"=>^C
  #    ["Tap X target creatures. <br/><i>Ferocious</i> &mdash; If you control a creature with power 4 or greater, those creatures don't untap during their controllers' next untap steps."],
  #   "class"=>"class mage.cards.i.IcyBlast",
  #   "superType"=>[],
  #   "rarity"=>"Special"},
  desc "bulk load json"
  task :bulk_load_json => :environment do
    count = 0
    scry = ScryfallClient.new
    scry_all = scry.map { |card| card }
    lookup_hash = Hash.new { |h,k|
      h[k] = (scry_all.find { |card| card.name == k } || scry.find_by_name(k))
    }
    scry_by_name = scry_all.each_with_object({}) do |card, cache|
      cache[card.name] = card
    end
    # {
    #   "object": "card",
    #  "id": "45000021-a6d9-4f86-a92e-3e52d1000c20",
    #  "multiverse_id": 247297,
    #  "multiverse_ids": [
    #                      247297
    #                    ],
    #  "mtgo_id": 40494,
    #  "name": "Austere Command",
    #  "uri": "https://api.scryfall.com/cards/cmd/8",
    #  "scryfall_uri": "https://scryfall.com/card/cmd/8?utm_source=api",
    #  "layout": "normal",
    #  "highres_image": true,
    #  "image_uri": "https://img.scryfall.com/cards/normal/en/cmd/8.jpg?1496788818",
    #  "image_uris": {
    #                  "small": "https://img.scryfall.com/cards/small/en/cmd/8.jpg?1496788818",
    #                 "normal": "https://img.scryfall.com/cards/normal/en/cmd/8.jpg?1496788818",
    #                 "large": "https://img.scryfall.com/cards/large/en/cmd/8.jpg?1496788818",
    #                 "png": "https://img.scryfall.com/cards/png/en/cmd/8.png?1496788818"
    #                },
    #  "cmc": 6,
    #  "type_line": "Sorcery",
    #  "oracle_text": "Choose two —\n• Destroy all artifacts.\n• Destroy all enchantments.\n• Destroy all creatures with converted mana cost 3 or less.\n• Destroy all creatures with converted mana cost 4 or greater.",
    #  "mana_cost": "{4}{W}{W}",
    #  "colors": [
    #              "W"
    #            ],
    #  "color_indicator": [],
    #  "color_identity": [
    #                      "W"
    #                    ],
    #  "legalities": {
    #                  "standard": "not_legal",
    #                 "frontier": "not_legal",
    #                 "modern": "legal",
    #                 "pauper": "not_legal",
    #                 "legacy": "legal",
    #                 "penny": "not_legal",
    #                 "vintage": "legal",
    #                 "duel": "legal",
    #                 "commander": "legal",
    #                 "1v1": "legal",
    #                 "future": "not_legal"
    #                },
    #  "reserved": false,
    #  "reprint": true,
    #  "set": "cmd",
    #  "set_name": "Commander 2011",
    #  "set_uri": "https://api.scryfall.com/cards/search?q=%2B%2Be%3Acmd",
    #  "set_search_uri": "https://api.scryfall.com/cards/search?q=%2B%2Be%3Acmd",
    #  "scryfall_set_uri": "https://scryfall.com/sets/cmd?utm_source=api",
    #  "prints_search_uri": "https://api.scryfall.com/cards/search?order=set&q=%2B%2B%21%22Austere+Command%22",
    #  "collector_number": "8",
    #  "digital": false,
    #  "rarity": "rare",
    #  "artist": "Wayne England",
    #  "frame": "2003",
    #  "full_art": false,
    #  "border_color": "black",
    #  "timeshifted": false,
    #  "colorshifted": false,
    #  "futureshifted": false,
    #  "edhrec_rank": 335,
    #  "usd": "9.35",
    #  "tix": "1.11",
    #  "eur": "5.21",
    #  "related_uris": {
    #                    "gatherer": "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=247297",
    #                   "tcgplayer_decks": "http://decks.tcgplayer.com/magic/deck/search?contains=Austere+Command&page=1&partner=Scryfall",
    #                   "edhrec": "http://edhrec.com/route/?cc=Austere+Command",
    #                   "mtgtop8": "http://mtgtop8.com/search?MD_check=1&SB_check=1&cards=Austere+Command"
    #                  },
    #  "purchase_uris": {
    #                     "amazon": "https://www.amazon.com/gp/search?ie=UTF8&index=toys-and-games&keywords=Austere+Command&tag=scryfall-20",
    #                    "ebay": "http://rover.ebay.com/rover/1/711-53200-19255-0/1?campid=5337966903&icep_catId=19107&icep_ff3=10&icep_sortBy=12&icep_uq=Austere+Command&icep_vectorid=229466&ipn=psmain&kw=lg&kwid=902099&mtid=824&pub=5575230669&toolid=10001",
    #                    "tcgplayer": "http://store.tcgplayer.com/magic/commander/austere-command?partner=Scryfall",
    #                    "magiccardmarket": "https://www.magiccardmarket.eu/Products/Singles/Commander/Austere+Command?referrer=scryfall",
    #                    "cardhoarder": "https://www.cardhoarder.com/cards/40494?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall",
    #                    "card_kingdom": "http://www.cardkingdom.com/catalog/item/184725?partner=scryfall&utm_campaign=affiliate&utm_medium=scryfall&utm_source=scryfall",
    #                    "mtgo_traders": "http://www.mtgotraders.com/deck/ref.php?id=40494&referral=scryfall",
    #                    "coolstuffinc": "http://www.coolstuffinc.com/p/Magic%3A+The+Gathering/Austere+Command?utm_source=scryfall"
    #                   }
    # }

    AbilityCard.bulk_insert do |bulk_card_ability|
      AbilityEffect.bulk_insert do |bulk_ability_effect|
        JSON(XMAGE_JSON_ABILITY_DUMP_PATH.read).each_with_index do |hash, index|
          next unless hash
          card = scry_by_name[hash['name']]
          card ||= scry.find_by_name(hash['name'])

          puts "[#{index}] SRCY FAILED - #{hash['name']}" unless card

          db_card = Card.where(name: [(card && card.name), hash['name']].compact).first

          unless [db_card, card].all?(&:blank?)
            db_card.destroy if db_card
            Card.create(name: card.name, )
          end
          puts "[#{index}] DB FAILED - #{hash['name']}" unless db_card
          puts "[#{index}] FAILED - #{hash['name']}" unless card
          # scope = ExpansionSet.where(id: hash["expansion"]).includes(:expansion_cards => :card).joins(:expansion_cards => :card)
          # set = scope.where(expansion_cards: {card_number: hash["cardNumber"]}).first

          # card = (set && set.expansion_cards.first && set.expansion_cards.first.card)
          # card ||= Card.where(name: hash["name"]).first
          # if card
          #   hash['abilities'].each do |a|
          #     next if a['zone'] == "HAND" && a['type'] == "Spell"
          #     key = JSON(zone: a['zone'], ability_type: a['type'], timing: a['timing'])
          #     ability = Ability.where(zone: a['zone'], ability_type: a['type'], timing: a['timing']).first_or_create
          #     a['effects'].each do |e|
          #       bulk_ability_effect.add(
          #         effect_id: Effect.where(xmage_class: e['class'], outcome: e['outcome'], effect_type: e['type']).first_or_create,
          #         ability_id: ability
          #       )
          #     end
          #     bulk_card_ability.add(ability_id: ability.id, card_id: card.id, rule: a['rule'], mana: a['mana'], costs: a['costs'])

          #   end
          #   count += 1
          # end
        end
      end
    end

    puts "#{count} FOUND"
  end

  desc "derive abilities from source"
  task :abilities => [:clone, :environment] do |t, args|
    [XMAGE_REPO_PATH, XMAGE_ABILITY_TYPES_PATH, XMAGE_ABILITIES_PATH].each do |path|
      path.dirname.mkpath unless path.dirname.exist?
    end

    Dir.chdir(XMAGE_REPO_PATH) do
      Dir.chdir("Mage.Sets/src/mage/cards") do
        sh("ack --no-heading 'import mage.abilities' > #{XMAGE_ABILITIES_PATH}")
      end
    end

    Rake::Task["xmage:add_abilities"].invoke
  end
end
