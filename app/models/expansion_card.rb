class ExpansionCard < ApplicationRecord
  belongs_to :expansion_set
  belongs_to :card
end
