# == Schema Information
#
# Table name: cards
#
#  id               :integer          not null, primary key
#  name             :string
#  mtg_card_id      :string
#  xmage_card_id    :string
#  color            :string
#  cost             :string
#  card_type        :string
#  card_sub_type    :string
#  power            :integer
#  toughness        :integer
#  raw_abilities    :string           default([]), is an Array
#  xmage_implemeted :boolean
#  deleted_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  xmage_name       :string
#

require 'rails_helper'

RSpec.describe Card, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
