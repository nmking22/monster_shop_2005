class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: [:packaged, :pending, :shipped, :cancelled]


  def grandtotal
    @total = []
    item_orders.each do |item_order|
    item = Item.find_by(id: item_order.item_id)
    discounts = Discount.where(merchant_id: item.merchant_id)
      if discounts != []
        best_discount = discounts.where('min_quantity <= ?', item_order.quantity).order('discount_percent DESC').first
         @total << item_total =  (item.price * item_order.quantity) - ((item.price * item_order.quantity) * (best_discount.discount_percent / 100.00))
      else
        @total << item_order.price * item_order.quantity
      end
    end
    @total.sum
  end

  def total_quantity_of_items
    item_orders.sum(:quantity)
  end

  def cancel_order
    self.update(status: 'cancelled')
    item_orders.each do |item_order|
      if item_order.status == 'fulfilled'
       item_order.item.inventory += item_order.quantity
      end
      # we need to test to make sure this is this doing the thing
       item_order.status = 'unfulfilled'
     end
  end

  def order_fulfilled
    if item_orders.all?{|order| order.status == 'fulfilled'}
      self.update(status: 'packaged')
    end
  end
end
