class AddMerchantsToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :discounts, :merchant, foreign_key: true
  end
end
