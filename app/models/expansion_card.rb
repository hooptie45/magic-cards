class ExpansionCard < ApplicationRecord
  belongs_to :expansion_set_id
  belongs_to :card_id
end
