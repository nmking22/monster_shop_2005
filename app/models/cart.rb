class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def decrement_item(item)
    @contents[item.id.to_s] -= 1
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end


  def discount(item)
    discounts = Discount.where(merchant_id: item.merchant_id)
    @eligible_discounts = discounts.where('min_quantity <= ?', @contents[item.id.to_s])
    @eligible_discounts
  end

  def discount_subtotal(item)
    best_discount = @eligible_discounts.order('discount_percent DESC').first
    price = (item.price * @contents[item.id.to_s]) - ((item.price * @contents[item.id.to_s]) * (best_discount.discount_percent / 100.00))
    price
  end

  def subtotal(item)
    if discount(item) !=  []
      discount_subtotal(item)
    else
      item.price * @contents[item.id.to_s]
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end


end
