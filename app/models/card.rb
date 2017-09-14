class Card < ApplicationRecord
  acts_as_taggable_on :tags

  has_many :expansion_cards
  has_many :expansion_sets, :through => :expansion_cards
  has_many :sales_prices, as: :purchasable
  scope :enchantment, -> { where(card_type: "Enchantment") }
  scope :artifact, -> { where(card_type: "Artifact") }
  scope :creature, -> { where(card_type: "Creature") }
  scope :instant, -> { where(card_type: "Instant") }

  scope :with_ability, ->(name) {

  }
  # after_save :derive_mana! #
  before_save :derive_xmage_name!, :if => ->(card) { card.xmage_name.blank? }
  has_many :manas, as: :mana_targetable, extend: ManaAssociation
  has_many :abilities, as: :targetable

  default_scope ->() {
    includes(:manas => :mana_type)
  }

  def derive_abilities!

  end

  def derive_xmage_name!
    self.xmage_name ||= self.name.scan(/[A-Za-z]+\s?/).map(&:strip).map(&:classify).join("")
  end

  def derive_mana!
    return manas if manas.present?
    transaction do
      raw_mana_flags = String(cost).split("$")

      raw_mana_flags.grep(ManaType::COST_REGEX_COLORLESS)
        .each {|mana_cost| manas.add_colorless(mana_cost) }

      raw_mana_flags.grep(ManaType::COST_REGEX_BLACK)
        .each {|_| manas.add_black }

      raw_mana_flags.grep(ManaType::COST_REGEX_BLUE)
        .each  {|_| manas.add_blue }

      raw_mana_flags.grep(ManaType::COST_REGEX_GREEN)
        .each {|_| manas.add_green }

      raw_mana_flags.grep(ManaType::COST_REGEX_RED)
        .each   {|_| manas.add_red }

      raw_mana_flags.grep(ManaType::COST_REGEX_WHITE)
        .each {|_| manas.add_white }
      manas
    end
  end
end
