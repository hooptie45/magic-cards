# == Schema Information
#
# Table name: ability_effects
#
#  id         :integer          not null, primary key
#  metadata   :json
#  ability_id :integer
#  effect_id  :integer
#

class AbilityEffect < ApplicationRecord
  belongs_to :ability
  belongs_to :effect
end
