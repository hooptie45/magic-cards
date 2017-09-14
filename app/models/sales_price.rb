class SalesPrice < ApplicationRecord
  belongs_to :purchasable, polymorphic: true
end
