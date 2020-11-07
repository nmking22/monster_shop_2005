require 'rails_helper'

RSpec.describe 'Merchant Discount' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Brett Dive Shop', address: '5786 Main St', city: 'Durango', state: 'CO', zip: 81301)

      @dave = @merchant_1.users.create(name: 'Dave', address: '123 CO St', city: 'Denver', state: 'CO', zip: 99876, email: 'dave@email.com', password: 'password', role: 1)
      @discount_1 = @merchant_1.discounts.create!(name: "Fall Discount", min_quantity: 10, discount_percent: 50 )
      @discount_2 = @merchant_1.discounts.create!(name: "Winter Discount", min_quantity: 5, discount_percent: 80 )
      @discount_3 = @merchant_1.discounts.create!(name: "Christmas Discount", min_quantity: 1, discount_percent: 99 )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dave)
    end

    it 'can see all discounts for the merchant' do
      visit "/merchant/discounts"
        within "#discount-#{@discount_1.id}" do
          expect(page).to have_link(@discount_1.name)
          expect(page).to have_content(@discount_1.min_quantity)
          expect(page).to have_content(@discount_1.discount_percent)
        end
        within "#discount-#{@discount_2.id}" do
          expect(page).to have_link(@discount_2.name)
          expect(page).to have_content(@discount_2.min_quantity)
          expect(page).to have_content(@discount_2.discount_percent)
        end
      end
    end
  end
