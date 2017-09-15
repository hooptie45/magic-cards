namespace :cards do
  desc "derive mana from raw mana flags and ingest into DB"
  task :derive_mana => [:environment] do |t, args|
    Mana.destroy_all
    Card.find_each(&:derive_mana!)
  end
end
