# == Schema Information
#
# Table name: expansion_sets
#
#  id         :string           not null, primary key
#  name       :string           not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExpansionSet < ApplicationRecord
  has_many :expansion_cards
  has_many :cards, :through => :expansion_cards
end
