class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    subtotal = price * quantity

    discounts = self.item.merchant.bulk_discounts
    discount =  discounts.apply_discount(quantity)
    if discount != nil
      discount.calculate_discount(subtotal)
    else
      subtotal
    end
  end
end
