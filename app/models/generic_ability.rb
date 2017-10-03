# == Schema Information
#
# Table name: abilities
#
#  id              :integer          not null, primary key
#  name            :string
#  type            :string
#  classification  :string
#  metadata        :json
#  sourceable_type :string
#  sourceable_id   :integer
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :string
#  timing          :string
#  rule            :string
#  zone            :string
#  ability_type    :string
#

class GenericAbility < Ability

end
