class Ability < ApplicationRecord
  has_many :card_abilities
  has_many :cards, :through => :card_abilities
  has_many :sources, :as => :sourceable

  

  def derive_mana!
    raw_mana_flags = String(cost).split("$")

    raw_mana_flags.grep(ManaType::COST_REGEX_COLORLESS)
      .each {|mana_flag| card.manas.add_black }

    raw_mana_flags.grep(ManaType::COST_REGEX_BLACK)
      .each {|mana_flag| card.manas.add_black }

    raw_mana_flags.grep(ManaType::COST_REGEX_BLUE)
      .each  {|mana_flag| card.manas.add_blue }

    raw_mana_flags.grep(ManaType::COST_REGEX_GREEN)
      .each {|mana_flag| card.manas.add_green }

    raw_mana_flags.grep(ManaType::COST_REGEX_RED)
      .each   {|mana_flag| card.manas.add_red }

    raw_mana_flags.grep(ManaType::COST_REGEX_WHITE)
      .each {|mana_flag| card.manas.add_white }
  end

end
