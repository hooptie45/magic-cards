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

require 'rails_helper'

RSpec.describe ExpansionCard, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
