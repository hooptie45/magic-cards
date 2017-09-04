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

  scope :code, ->(code) { where(code: code) }

  scope :colorless,-> { code(CODE_COLORLESS) }
  scope :black, -> { code(CODE_BLACK) }
  scope :blue,  -> { code(CODE_BLUE) }
  scope :green, -> { code(CODE_GREEN) }
  scope :red,   -> { code(CODE_RED) }
  scope :white, -> { code(CODE_WHITE) }

end
