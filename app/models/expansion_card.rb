# == Schema Information
#
# Table name: expansion_cards
#
#  id               :integer          not null, primary key
#  expansion_set_id :string
#  card_id          :integer
#  rarity           :string
#  card_number      :integer
#  deleted_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ExpansionCard < ApplicationRecord

  belongs_to :expansion_set
  belongs_to :card
end
