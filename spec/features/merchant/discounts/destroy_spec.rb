require 'rails_helper'

RSpec.describe 'Merchant Discount' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Brett Dive Shop', address: '5786 Main St', city: 'Durango', state: 'CO', zip: 81301)

      @dave = @merchant_1.users.create(name: 'Dave', address: '123 CO St', city: 'Denver', state: 'CO', zip: 99876, email: 'dave@email.com', password: 'password', role: 1)
      @discount_1 = @merchant_1.discounts.create!(name: "Fall Discount", min_quantity: 10, discount_percent: 50 )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dave)
    end

    it 'can delete a discount and see flash message' do
      visit "/merchant/discounts/#{@discount_1.id}"
      click_button "Delete Discount"
      save_and_open_page
      expect(page).to_not have_content(@discount_1.min_quantity)
      expect(page).to_not have_content(@discount_1.discount_percent)
      expect(page).to have_content("#{@discount_1.name} has been deleted.")
    end
  end
end
