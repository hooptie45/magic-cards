# == Schema Information
#
# Table name: ability_cards
#
#  id         :integer          not null, primary key
#  card_id    :integer
#  ability_id :integer
#  metadata   :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mana       :json             is an Array
#  costs      :json             is an Array
#  rule       :string
#

class AbilityCard < ApplicationRecord
  belongs_to :card
  belongs_to :ability
end
