# == Schema Information
#
# Table name: sources
#
#  id              :integer          not null, primary key
#  name            :string
#  line            :string
#  filename        :string
#  git_sha         :string
#  sourceable_id   :integer
#  sourceable_type :string
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Source < ApplicationRecord
  belongs_to :sourceable, :polymorphic => true
end
