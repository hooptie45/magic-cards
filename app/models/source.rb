class Source < ApplicationRecord
  belongs_to :sourceable, :polymorphic => true
end
