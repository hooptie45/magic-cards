class Ability < ApplicationRecord
  has_many :manas, as: :mana_targetable, extend: ManaAssociation
  has_and_belongs_to_many :cards

  acts_as_taggable_on :tags, :ability_tags, :colors, :card_types,
                      :card_sub_types, :rarities, :enhancements

  def self.sanitized_name(name)
    first, *middle, last = name.split(".")
    [last, middle].flatten.map(&:underscore).flatten.map(&:upcase).join("_")
  end
  def derive_endfrom

  end

  def watch_for(name)
    description=~ /creatures you control gets? (.*?)/
    description=~ /creatures you control gets? (.*?)/
    description=~ /creatures you control gets? (.*?)/
  end


  def derive!
    if description =~ /creatures you control gets? (.*?)/
      boost = nil
      Rails.logger.silence do
        self.tag_list.add("Creature-Enhancer")
        boost = $1
        self.enhancement_list.add($1) if boost
      end
      Rails.logger.info "#{self} added Creature-Enhancer #{boost}"
      puts "#{self} added Creature-Enhancer #{boost}"
      end

    if description =~ /where X is/
      Rails.logger.silence do
        self.tag_list.add("Multiplier")
      end
      Rails.logger.info "#{self} added Multiplier"
      puts "#{self} added Multiplier"
    end
    save
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
