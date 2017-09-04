class Card < ApplicationRecord
  has_many :expansion_cards
  has_many :expansion_sets, :through => :expansion_cards
  has_many :sales_prices, as: :purchasable

  before_save :derive_mana!, :if => ->(card) { card.mana.count.zero? }

  has_many :manas, as: :mana_targetable do
    def add_black
      add_mana(:black)
    end

    def add_blue
      add_mana(:blue)
    end

    def add_green
      add_mana(:green)
    end

    def add_red
      add_mana(:red)
    end

    def add_white
      add_mana(:white)
    end

    def add_colorless
      build(mana_type: ManaType.colorless.first)
    end

    def add_mana(color_name)
      build(mana_type: ManaType.public_send(color_name).first)
    end
  end

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
