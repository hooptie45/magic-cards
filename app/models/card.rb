# == Schema Information
#
# Table name: cards
#
#  id               :integer          not null, primary key
#  name             :string
#  mtg_card_id      :string
#  xmage_card_id    :string
#  color            :string
#  cost             :string
#  card_type        :string
#  card_sub_type    :string
#  power            :integer
#  toughness        :integer
#  raw_abilities    :string           default([]), is an Array
#  xmage_implemeted :boolean
#  deleted_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  xmage_name       :string
#

class Card < ApplicationRecord
  include ManaAssociation
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :expansion_cards
  has_many :expansion_sets, :through => :expansion_cards
  has_many :sales_prices, as: :purchasable

  has_many :ability_cards
  has_many :abilities, through: :ability_cards

  has_many :abilities, through: :ability_cards

  scope :enchantment, -> { where(card_type: "Enchantment") }
  scope :artifact, -> { where(card_type: "Artifact") }
  scope :creature, -> { where(card_type: "Creature") }
  scope :instant, -> { where(card_type: "Instant") }

  scope :with_ability, ->(name) {
    ActsAsTaggableOn::Tag.where(["name LIKE n#"])
  }

  def mana_cost
    manas.sum { |mana| mana.mana_type.cost }
  end

  def as_indexed_json(opts = {})
    _manas = derive_mana!

    as_json.merge(
      :mana_cost      => _manas.sum { |mana| mana.cost },
      :manas          => _manas.map { |mana| mana.as_json },
      :rarities       => expansion_cards.map(&:rarity).uniq.sort,
      :abilities      => abilities,
      :colors         => _manas.map { |mana| mana.color }.uniq,
      :expansion_sets => expansion_sets.map(&:id).sort
    )
  end

  def derive_xmage_name!
    self.xmage_name ||= self.name.scan(/[A-Za-z]+\s?/).map(&:strip).map(&:classify).join("")
  end


  def derive_mana!
    ManaType.setup! unless ManaType.respond_to?(:fetch_white)

    raw_mana_flags = String(cost).split("$")
    manas.clear

    raw_mana_flags.grep( ManaType::COST_REGEX_COLORLESS).each do |mana_cost|
      add_colorless(mana_cost)
    end

    raw_mana_flags.grep(ManaType::COST_REGEX_BLACK).each do |_|
      add_black
    end

    raw_mana_flags.grep(ManaType::COST_REGEX_BLUE).each  do |_|
      add_blue
    end

    raw_mana_flags.grep(ManaType::COST_REGEX_GREEN).each do |_|
      add_green
    end

    raw_mana_flags.grep(ManaType::COST_REGEX_RED).each   do |_|
      add_red
    end

    raw_mana_flags.grep(ManaType::COST_REGEX_WHITE).each do |_|
      add_white
    end
    manas
  end
end
