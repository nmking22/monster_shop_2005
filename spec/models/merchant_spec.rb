require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :bulk_discounts }
    it { should have_many :items }
    it { should have_many(:item_orders).through(:items) }
    it { should have_many :users }
    it { should have_many(:orders).through(:item_orders) }
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password",
                            role: 1,
                            merchant: @meg)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = @user.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to include("Denver")
      expect(@meg.distinct_cities).to include("Hershey")
    end

    it '#full_address' do
      expect(@meg.full_address).to eq("123 Bike Rd., Denver, CO 80203")
    end

    it '#pending_orders' do
      order_1 = @user.orders.create!(
          name: 'Ogirdor',
          address: '1 2nd St.',
          city: 'Bloomington',
          state: 'IN',
          zip: '24125'
        )
      order_2 = @user.orders.create!(
          name: 'Drew Lock',
          address: '1 2nd St.',
          city: 'Bloomington',
          state: 'IN',
          zip: '24125',
          status: 2
        )
        ItemOrder.create!(
          item: @tire,
          order: order_1,
          quantity: 1,
          price: (@tire.price * 1)
        )
        ItemOrder.create!(
          item: @tire,
          order: order_2,
          quantity: 500,
          price: (@tire.price * 500)
        )

      expect(@meg.pending_orders).to eq([order_1])
    end
  end
end
