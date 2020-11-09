require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]

      @user = User.create!(name: "Batman",
                            address: "Some dark cave 11",
                            city: "Arkham",
                            state: "CO",
                            zip: "81301",
                            email: 'batmansemail@email.com',
                            password: "password")
    end

    it 'Theres a link to checkout if logged in' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end

    it 'Theres is not link to checkout if not logged in, instead login/register' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
      expect(page).to have_content("You must register or log in to finish the checkout process")

      within('.checkin') do
        expect(page).to have_link("Log In")
        expect(page).to have_link("Register")
      end
    end

    it 'As a registered user, I can checkout' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/cart"

      expect(page).to have_link("Checkout")
      click_on "Checkout"

      expect(current_path).to eq("/orders/new")

      fill_in :name, with: @user.name
      fill_in :address, with: @user.address
      fill_in :city, with: @user.city
      fill_in :state, with: @user.state
      fill_in :zip, with: @user.zip

      click_on 'Create Order'
      expect(current_path).to eq('/profile/orders')

      expect(page).to have_content("The order was created")
      expect(page).to have_content("Cart: 0")

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end

  describe 'when I add enough of an item' do
      before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @user = User.create!(name: "Batman",
                          address: "Some dark cave 11",
                          city: "Arkham",
                          state: "CO",
                          zip: "81301",
                          email: 'batmansemail@email.com',
                          password: "password")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @mike.discounts.create!(name: 'Fall Discount', min_quantity: 2, discount_percent: 50)
    end

    it 'I see the discount flash message when increment item' do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit '/cart'
      within("#cart-item-#{@paper.id}") do
       click_on "+"
      end
      expect(page).to have_content("Fall Discount of 50% off has been applied to Lined Paper!")
    end

    it 'I see the discount flash message when increment item' do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit '/cart'
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit '/cart'  
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit '/cart'
      #so there are now three paper but when we decrement the flash will be valid until 1 item is left.
        within("#cart-item-#{@paper.id}") do
         click_on "-"
        end
      expect(page).to have_content("Fall Discount of 50% off has been applied to Lined Paper!")
        within("#cart-item-#{@paper.id}") do
         click_on "-"
        end
      expect(page).to_not have_content("Fall Discount of 50% off has been applied to Lined Paper!")
    end
 end
end
