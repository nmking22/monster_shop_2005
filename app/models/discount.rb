class Discount < ApplicationRecord
  has_many :discount_items
  has_many :items, through: :discount_items
end
