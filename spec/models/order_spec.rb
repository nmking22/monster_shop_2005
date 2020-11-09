require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it { should belong_to :user }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password")

      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it '#grandtotal' do
      @meg.discounts.create!(name: 'Fall Discount', min_quantity: 2, discount_percent: 50)
      expect(@order_1.grandtotal).to eq(130)
    end

    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#total_quantity_of_items' do
      expect(@order_1.total_quantity_of_items).to eq(5)

    end

    it '#cancel_order' do
      item_order_3 = @order_1.item_orders.create!(
        item: @pull_toy,
        price: @pull_toy.price,
        quantity: 3,
        status: "fulfilled"
      )

      expect(@pull_toy.inventory).to eq(32)

      expect(@order_1.status).to eq('pending')
      @order_1.cancel_order
      expect(@order_1.status).to eq('cancelled')
      expect(@order_1.item_orders.first.status).to eq('unfulfilled')

      expect(@pull_toy.inventory).to eq(35)
     end

     it '#order_fulfilled' do
       expect(@order_1.status).to eq('pending')
       @order_1.item_orders.each{|order| order.status = 'fulfilled' }
       @order_1.order_fulfilled
       expect(@order_1.status).to eq('packaged')
     end

     it '#full_address' do
       expect(@order_1.full_address).to eq("123 Stang Ave, Hershey, PA 17033")
     end
  end
end
