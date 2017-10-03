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

require 'rails_helper'

RSpec.describe Effect, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
