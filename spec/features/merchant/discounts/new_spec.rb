require 'rails_helper'

RSpec.describe 'Merchant Discount' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Brett Dive Shop', address: '5786 Main St', city: 'Durango', state: 'CO', zip: 81301)
      @dave = @merchant_1.users.create(name: 'Dave', address: '123 CO St', city: 'Denver', state: 'CO', zip: 99876, email: 'dave@email.com', password: 'password', role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@dave)
    end

    it 'can create a new discount' do
      visit '/merchant'
      click_on "Create New Discount"
      expect(current_path).to eq("/merchant/discounts/new")
      fill_in :name, with: 'Fall Discount'
      fill_in :min_quantity, with: 5
      fill_in :discount_percent, with: 50
      click_button 'Create New Discount'
      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("All Discounts for #{@merchant_1.name}")
      expect(page).to have_content("Fall Discount")
      expect(page).to have_content('Discount min quantity: 5')
      expect(page).to have_content('Discount percent off: 50%')
    end

    it 'can see flash message when discount is missing field' do
      visit '/merchant'
      click_on "Create New Discount"
      expect(current_path).to eq("/merchant/discounts/new")
      fill_in :name, with: ''
      fill_in :min_quantity, with: 5
      fill_in :discount_percent, with: 50
      click_button 'Create New Discount'
      expect(page).to have_content("Name can't be blank")
    end
  end
end
