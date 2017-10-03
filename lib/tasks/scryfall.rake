namespace :scryfall do
  desc "ingest"
  task :ingest => [:environment] do |t, args|
    scope = Card.where

    ScryfallClient.new.find_each do |row, path, mash|
      scope = Card.where(name: row['name']).first
      puts scope
    end
  end
end
