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

require 'rails_helper'

RSpec.describe ExpansionSet, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
