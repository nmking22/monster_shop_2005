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




    # def subtotal(item)
    #   binding.pry
    #   discounts = Discount.find_by(merchant_id: item.merchant_id)
    #   if item.
    #   if discount
    #     discounts.order(discount_percent: :desc)
    #   item.price * @contents[item.id.to_s]
    # end

  def discount_subtotal(item)
    discounts = Discount.where(merchant_id: item.merchant_id)
    best_discount_amount = discounts.where('min_quantity <= ?', @contents[item.id.to_s]).order('discount_percent DESC').first.discount_percent
    price = (item.price * @contents[item.id.to_s]) * (best_discount_amount / 100.00)
    price
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end


end
