require 'rails_helper'

describe 'As a merchant user creating a new bulk discount' do
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

    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = @user.orders.create!(
      name: 'Rodrigo',
      address: '2 1st St.',
      city: 'South Park',
      state: 'CO',
      zip: '84125'
    )

    @item_order = ItemOrder.create!(item: @pull_toy, order: @order_1, quantity: 20, price: (@pull_toy.price * 2))

    @bulk_discount_1 = BulkDiscount.create!(
      description: "5% on 20+",
      discount_percent: 5,
      minimum_quantity: 20,
      merchant: @dog_shop
    )

    @bulk_discount_new = BulkDiscount.new(
      description: "15% on 50+",
      discount_percent: 15,
      minimum_quantity: 50,
      merchant: @dog_shop
    )
  end

  it "I can create a new bulk discount" do
    visit "/merchant/bulk_discounts"

    click_on 'Create a New Discount'

    fill_in :description, with: "15% on 50+"
    fill_in :discount_percent, with: 15
    fill_in :minimum_quantity, with: 50

    click_on 'Create Bulk Discount'
    expect(current_path).to eq('/merchant/bulk_discounts')

    expect(page).to have_content("15% on 50+")
    expect(page).to have_content("Percentage: 15%")
    expect(page).to have_content("Minimum Quantity: 50")
  end
end
