class Mana < ApplicationRecord
  belongs_to :mana_type
  belongs_to :mana_targetable, polymorphic: true

  scope :find_mana_type, ->(type) { joins(:mana_type).where(mana_type: type) }

  scope :colorless,-> { find_mana_type(ManaType.colorless) }
  scope :add_colorless,-> { joins(:mana_type).create(mana_type: colorless) }
  scope :black, -> { find_mana_type(ManaType.black) }
  scope :blue,  -> { find_mana_type(ManaType.blue) }
  scope :green, -> { find_mana_type(ManaType.green) }
  scope :red,   -> { find_mana_type(ManaType.red) }
  scope :white, -> { find_mana_type(ManaType.white) }
end
