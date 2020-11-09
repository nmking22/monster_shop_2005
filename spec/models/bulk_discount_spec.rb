require 'rails_helper'

describe BulkDiscount do
  describe 'Validations' do
    it { should validate_presence_of :description }
    it { should validate_presence_of :minimum_quantity }
    it { should validate_presence_of :discount_percent }
  end

  describe 'Relationships' do
    it { should belong_to :merchant}
  end

  describe 'Instance Methods' do
    before :each do
      @dog_shop = Merchant.create(
        name: "Brian's Dog Shop",
        address: '125 Doggo St.',
        city: 'Denver',
        state: 'CO',
        zip: 80210
      )
      @user = User.create!(
        name: "Batman",
        address: "Some dark cave 11",
        city: "Arkham",
        state: "CO",
        zip: "81301",
        email: 'batmansemail@email.com',
        password: "password",
        role: 1,
        merchant: @dog_shop
      )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 50)

      @order_1 = @user.orders.create!(
        name: 'Rodrigo',
        address: '2 1st St.',
        city: 'South Park',
        state: 'CO',
        zip: '84125'
      )

      @order_2 = @user.orders.create!(
        name: 'Jeremih',
        address: '1st 2nd St.',
        city: 'Aspen',
        state: 'CO',
        zip: '84128'
      )
      @item_order_1 = ItemOrder.create!(item: @pull_toy, order: @order_1, quantity: 20, price: (@pull_toy.price * 2))

      @item_order_2 = ItemOrder.create!(item: @pull_toy, order: @order_1, quantity: 10, price: (@pull_toy.price * 2))

      @bulk_discount_1 = BulkDiscount.create!(
        description: "5% on 20+",
        discount_percent: 5,
        minimum_quantity: 20,
        merchant: @dog_shop
      )
    end

    it '#calculate_discount' do
      order_total = @item_order_1.quantity * @item_order_1.price
      expect(@bulk_discount_1.calculate_discount(order_total)).to eq(400 * 0.95)
    end

    it '#apply_discount' do

      expect(@dog_shop.bulk_discounts.apply_discount(@item_order_2.quantity)).to eq(nil)
      expect(@dog_shop.bulk_discounts.apply_discount(@item_order_1.quantity)).to eq(@bulk_discount_1)
    end
  end
end
