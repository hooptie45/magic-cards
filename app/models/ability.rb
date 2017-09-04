class Ability < ApplicationRecord
  has_many :card_abilities
  has_many :cards, :through => :card_abilities
  has_many :sources, :as => :sourceable
end
