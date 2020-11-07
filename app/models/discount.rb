class Discount < ApplicationRecord
  validates_presence_of :name, :min_quantity, :discount_percent

  belongs_to :merchant
end
