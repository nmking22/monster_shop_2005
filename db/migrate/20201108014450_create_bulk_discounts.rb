class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :description
      t.integer :discount_percent
      t.integer :minimum_quantity
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
