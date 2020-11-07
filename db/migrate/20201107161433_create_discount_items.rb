class CreateDiscountItems < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_items do |t|
      t.references :item, foreign_key: true
      t.references :discount, foreign_key: true

      t.timestamps
    end
  end
end
