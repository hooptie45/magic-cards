class ExpansionSet < ApplicationRecord
  has_many :expansion_cards
  has_many :cards, :through => :expansion_cards
end
