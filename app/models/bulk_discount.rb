class BulkDiscount < ApplicationRecord
  validates_presence_of :description, :discount_percent, :minimum_quantity

  belongs_to :merchant

  def calculate_discount(total)
    total * ((100 - discount_percent) * 0.01)
  end

  def self.apply_discount(quantity)
    order(:minimum_quantity).where("minimum_quantity <= ?", quantity).last
  end
end
