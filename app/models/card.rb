class Card < ApplicationRecord
  acts_as_taggable_on :tags, :ability_tags, :colors, :card_types,
                      :card_sub_types, :rarities

  has_many :expansion_cards
  has_many :expansion_sets, :through => :expansion_cards
  has_many :sales_prices, as: :purchasable

  scope :enchantment, -> { where(card_type: "Enchantment") }
  scope :artifact, -> { where(card_type: "Artifact") }
  scope :creature, -> { where(card_type: "Creature") }
  scope :instant, -> { where(card_type: "Instant") }
  scope :search_by_name, ->(name) {
    where(["name ILIKE ?", "%#{name}%"])
  }
  scope :with_ability, ->(name) {
    ActsAsTaggableOn::Tag.where(["name LIKE n#"])
  }
  has_many :manas, as: :mana_targetable, extend: ManaAssociation

  has_and_belongs_to_many :abilities

  def derive_xmage_name!
    self.xmage_name ||= self.name.scan(/[A-Za-z]+\s?/).map(&:strip).map(&:classify).join("")
  end

  def derive_abilities!
    raw_abilities.each do |description|
      Abilities
    end
  end

  def derive_rarity!
    expansion_cards.each do |expansion|
      ([self] + abilities).each do |target|
        target.rarity_list.add(expansion.rarity)
        target.save!
      end
    end
  end

  def derive_mana!
    ManaType.setup! unless ManaType.respond_to?(:fetch_white)

    transaction do
      manas.destroy_all

      card_type_list.add(card_type)

      if card_sub_type.present?
        card_sub_type_list.add(card_sub_type)
      end

      raw_mana_flags = String(cost).split("$")

      raw_mana_flags.grep(ManaType::COST_REGEX_COLORLESS).each do |mana_cost|
        manas.add_colorless(mana_cost)
        color_list.add("colorless")
      end

      raw_mana_flags.grep(ManaType::COST_REGEX_BLACK).each do |_|
        manas.add_black
        color_list.add("black")
      end

      raw_mana_flags.grep(ManaType::COST_REGEX_BLUE).each  do |_|
        manas.add_blue
        color_list.add("blue")
      end

      raw_mana_flags.grep(ManaType::COST_REGEX_GREEN).each do |_|
        manas.add_green
        color_list.add("green")
      end

      raw_mana_flags.grep(ManaType::COST_REGEX_RED).each   do |_|
        manas.add_red
        color_list.add("red")
      end

      raw_mana_flags.grep(ManaType::COST_REGEX_WHITE).each do |_|
        manas.add_white
        color_list.add("white")
      end
      save!

      abilities.destroy_all

      raw_abilities.each do |raw|
        ability = Ability.where(description: raw).first_or_create
        self.abilities << ability
      end

      manas
    end
  end
end
