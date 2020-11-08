class BulkDiscount < ApplicationRecord
  validates_presence_of :description, :discount_percent, :minimum_quantity

  belongs_to :merchant
end
