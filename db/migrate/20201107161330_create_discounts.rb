class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.integer :min_quantity, default: 0
      t.integer :discount_percent, default: 0

      t.timestamps
    end
  end
end
