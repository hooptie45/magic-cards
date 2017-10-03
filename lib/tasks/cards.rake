require 'hashie'

namespace :cards do

  desc "ingest from xmage dump"
  task :ingest_expansion_sets => [:environment] do |t, args|
    Card.find_each do |card|
      Rails.cache.write("card/xmage_card_id/#{card.xmage_card_id}", card.id, expires_in: 1.day)
    end
    expansion_sets = {}
    ExpansionCard.bulk_insert do |worker|
      Pathname.glob(Rails.root.join("data/xmage/*.json")).sort_by {|p| p.basename.to_s.to_i }.each do |path|
        json = JSON.load(path.read)
        json["rowsData"].each_with_index do |raw_hash, index|
          hash = Hashie::Mash.new(raw_hash)
          hash.editions.each do |edition|
            code = edition.expansionCode
            card_id = Rails.cache.read("card/xmage_card_id/#{hash.id}")
            expansion = expansion_sets[code]
            if !expansion
              expansion = ExpansionSet.where(id: code).first_or_create(name: edition.expansionName)
              expansion_sets[code] = expansion
            end

            worker.add(rarity: edition.rarity,
                       expansion_set_id: expansion.id,
                       card_number: edition.cardNumber,
                       card_id: card_id)
          end
        end
      end
    end
  end

  desc "ingest from xmage dump"
  task :ingest => [:environment] do |t, args|
    work_q = Queue.new
    ManaType.setup!
    Card.destroy_all

    Pathname.glob(Rails.root.join("data/xmage/*.json")).sort_by {|p| p.basename.to_s.to_i }.each do |p|
      work_q.push(p)
    end

    card_worker = Card.bulk_insert
    expansion_cards_worker = Card.bulk_insert

    workers = (0...8).map do
      Thread.new do
        begin
          while path = work_q.pop(true)
            json = JSON.load(path.read)
            json["rowsData"].each_with_index do |raw_hash, index|
              hash = Hashie::Mash.new(raw_hash)
              next unless hash.id
              Rails.cache.delete("card/xmage_card_id/#{hash.id}")

              card_worker.add(
                id: hash.id,
                name: hash.name,
                card_type: hash.type,
                card_sub_type: hash.subType,
                xmage_card_id: hash.id,
                power: hash.power,
                toughness:  hash.toughness,
                cost: hash.cost,
                xmage_name: hash.name.scan(/[A-Za-z]+\s?/).map(&:strip).map(&:classify).join(""),
                raw_abilities: String(hash.abilities).split("$")
              )
            end
          end
        rescue ThreadError => e
          Rails.logger.error("Cards[INGEST] ThreadError: #{e}")
        end
      end
    end

    workers.map(&:join)
    Rake::Task["cards:ingest_expansion_sets"].invoke
    Rake::Task["xmage:abilities"].invoke
    Rake::Task["cards:push_to_search"].invoke
  end

  desc "push to search"
  task :push_to_search => [:environment] do |t, args|
    Card.import(
      refresh: true,
      force: true,
      query: ->() do
        Card.includes(:abilities).includes(:expansion_sets)
      end
    )
  end
end
