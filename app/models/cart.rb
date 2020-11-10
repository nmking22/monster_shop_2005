class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item_id)
    @contents[item_id] = 0 if !@contents[item_id]
    @contents[item_id] += 1
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

  def subtotal(item_id)
    subtotal = Item.find(item_id).price * @contents[item_id.to_s]
    discounts = Item.find(item_id).merchant.bulk_discounts
    discount = discounts.apply_discount(@contents[item_id.to_s])
    if discount != nil
      discount.calculate_discount(subtotal)
    else
      subtotal
    end
  end

  def total
    total = 0.0
    @contents.each do |item_id,quantity|
      total += subtotal(item_id)
    end
    total
  end

  def decrement_item(item)
    @contents[item.id.to_s] -= 1
  end

end
