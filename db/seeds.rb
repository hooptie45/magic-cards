ManaType.setup!
ActsAsTaggableOn.tags_counter = false
require_relative "seed/cards"
Rake::Task["cards:derive_mana"].invoke
require_relative "seed/expansion_sets"
require_relative "seed/expansion_cards"
Rake::Task["xmage:abilities"].invoke

ActsAsTaggableOn.tags_counter = true
