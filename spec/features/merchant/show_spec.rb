require 'rails_helper'

describe "As a merchant employee, when I visit '/merchant'" do
  before :each do
    @dog_shop = Merchant.create(
      name: "Brian's Dog Shop",
      address: '125 Doggo St.',
      city: 'Denver',
      state: 'CO',
      zip: 80210
    )
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

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
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
  end

  it 'I see the name and full address of the merchant I work for' do
    visit '/merchant'

    expect(page).to have_content(@user.name)
    expect(page).to have_content(@dog_shop.full_address)
  end

  it 'I see a link to view my own items which redirects me to /merchant/items.' do
    visit '/merchant'

    expect(page).to have_link('View My Items')

    click_link 'View My Items'

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content(@pull_toy.name)
    expect(page).to have_content(@dog_bone.name)
    expect(page).to have_no_content(@tire.name)
  end

  it 'Can see pending orders with merchant items' do
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
    order_3 = @user.orders.create!(
        name: 'Derek Carr',
        address: '1 2nd St.',
        city: 'Bloomington',
        state: 'IN',
        zip: '24125'
      )
    item_order = ItemOrder.create!(
      item: @pull_toy,
      order: order_1,
      quantity: 1,
      price: (@pull_toy.price * 1)
    )
    item_order = ItemOrder.create!(
      item: @dog_bone,
      order: order_2,
      quantity: 500,
      price: (@dog_bone.price * 500)
    )
    item_order = ItemOrder.create!(
      item: @tire,
      order: order_3,
      quantity: 200,
      price: (@tire.price * 200)
    )

    visit '/merchant'

    expect(page).to have_content("Pending Orders")

    within "#order-#{order_1.id}" do
      expect(page).to have_link("#{order_1.id}")
      expect(page).to have_content("#{order_1.created_at}")
      expect(page).to have_content("#{order_1.total_quantity_of_items}")
      expect(page).to have_content("$10.00")
    end

    # no content because order status is shipped
    expect(page).not_to have_link("#{order_2.id}")
    expect(page).not_to have_content("#{order_2.total_quantity_of_items}")

    # no content because order assigned to different merchant
    expect(page).not_to have_link("#{order_3.id}")
    expect(page).not_to have_content("#{order_3.total_quantity_of_items}")
  end

  it "I can see a link for bulk discounts" do
    visit "/merchant"

    expect(page).to have_link('Bulk Discounts')
    click_on 'Bulk Discounts'
    expect(current_path).to eq('/merchant/bulk_discounts')
  end
end
