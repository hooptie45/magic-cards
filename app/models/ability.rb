class Ability < ApplicationRecord
  has_many :manas, as: :mana_targetable, extend: ManaAssociation
  has_many :ability_cards
  has_many :cards, :through => :ability_cards

  has_and_belongs_to_many :meta_abilities

  def self.add_meta_ability(name, ability_tags:)
    name = sanitized_name(name)

    Card.tagged_with(ability_tags, :on => :ability_tags, :any => true).find_each do |card|
      card.meta_ability_tag_list.add(name)
      card.save
    end
  end

  def self.sanitized_name(name)
    name.split(/[.\-_ ]/).flatten.compact.map(&:underscore).flatten.map(&:upcase).join("_")
  end

  def watch_for(name)
    description=~ /creatures you control gets? (.*?)/
    description=~ /creatures you control gets? (.*?)/
    description=~ /creatures you control gets? (.*?)/
  end

  def derive_mana!
    raw_mana_flags = String(cost).split("$")

    description.grep(ManaType::ABILITY_COST_REGEX_COLORLESS).each do |mana_flag|
      manas.add_black
    end

    description.grep(ManaType::ABILITY_COST_REGEX_BLACK).each do |mana_flag|
      manas.add_black
    end

    description.grep(ManaType::ABILITY_COST_REGEX_BLUE).each  do |mana_flag|
      manas.add_blue
    end

    description.grep(ManaType::ABILITY_COST_REGEX_GREEN).each do |mana_flag|
      manas.add_green
    end

    description.grep(ManaType::ABILITY_COST_REGEX_RED).each   do |mana_flag|
      manas.add_red
    end

    description.grep(ManaType::ABILITY_COST_REGEX_WHITE).each do |mana_flag|
      manas.add_white
    end
  end

end
