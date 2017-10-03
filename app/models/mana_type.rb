# == Schema Information
#
# Table name: mana_types
#
#  id   :string           not null, primary key
#  name :string           not null
#  cost :integer          default(1), not null
#

class ManaType < ApplicationRecord
  has_many :manas

  CODE_COLORLESS = Array(1..9).freeze
  CODE_BLACK = "B".freeze
  CODE_BLUE  = "U".freeze
  CODE_GREEN = "G".freeze
  CODE_RED   = "R".freeze
  CODE_WHITE = "W".freeze

  COST_REGEX_COLORLESS = /[1-9,*]{1}/
  COST_REGEX_BLACK = Regexp.new(CODE_BLACK)
  COST_REGEX_BLUE  = Regexp.new(CODE_BLUE)
  COST_REGEX_GREEN = Regexp.new(CODE_GREEN)
  COST_REGEX_RED   = Regexp.new(CODE_RED)
  COST_REGEX_WHITE = Regexp.new(CODE_WHITE)

  ABILITY_COST_REGEX_COLORLESS = Regexp.new(%Q[{([1-9]{1,2})}])
  ABILITY_COST_REGEX_BLACK = Regexp.new(%Q[{(#{ManaType::CODE_BLACK})}])
  ABILITY_COST_REGEX_BLUE  = Regexp.new(%Q[{(#{ManaType::CODE_BLUE})}])
  ABILITY_COST_REGEX_GREEN = Regexp.new(%Q[{(#{ManaType::CODE_GREEN})}])
  ABILITY_COST_REGEX_RED   = Regexp.new(%Q[{(#{ManaType::CODE_RED})}])
  ABILITY_COST_REGEX_WHITE = Regexp.new(%Q[{(#{ManaType::CODE_WHITE})}])

  scope :code, ->(code) { where(id: code) }

  scope :colorless, ->(colorless_cost = nil) { code(colorless_cost || CODE_COLORLESS) }
  scope :black, -> { code(CODE_BLACK) }
  scope :blue,  -> { code(CODE_BLUE) }
  scope :green, -> { code(CODE_GREEN) }
  scope :red,   -> { code(CODE_RED) }
  scope :white, -> { code(CODE_WHITE) }


  scope :black, -> { code(CODE_BLACK) }
  scope :blue,  -> { code(CODE_BLUE) }
  scope :green, -> { code(CODE_GREEN) }
  scope :red,   -> { code(CODE_RED) }
  scope :white, -> { code(CODE_WHITE) }

  def self.setup!
    Array(1..20).each do |colorless_cost|
      colorless(colorless_cost).first_or_create(name: :colorless,
                                                cost: colorless_cost)

      define_singleton_method("fetch_#{colorless_cost}") do
        Rails.cache.fetch "mana_type/colorless_#{colorless_cost}" do
          colorless(colorless_cost).first
        end
      end
    end

    %w(black blue green red white).each do |color|
      public_send(color).first_or_create(name: color)
      define_singleton_method("fetch_#{color}") do
        Rails.cache.fetch "mana_type/#{color}" do
          public_send(color).first
        end
      end
    end
  end
end
