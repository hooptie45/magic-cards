# == Schema Information
#
# Table name: effects
#
#  id          :integer          not null, primary key
#  xmage_class :string
#  values      :string
#  outcome     :string
#  effect_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Effect < ApplicationRecord
  has_many :ability_effects
  has_many :abilities, :through => :ability_effects
  has_many :cards, :through => :abilities
end
