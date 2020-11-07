require 'rails_helper'

RSpec.describe 'review edit and update', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
  end
  describe "when I visit the item show page" do
    it "I see a link next to each review to delete it" do
      review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

      reviews = [review_1,review_2,review_3,review_4,review_5]

      visit "/items/#{@chain.id}"

      reviews.each do |review|
        within "#review-#{review.id}" do
          expect(page).to have_link("Delete")
        end
      end
    end

    it "I can delete a review when I click on delete" do
      review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      review_1_id = review_1.id
      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        click_on "Delete"
      end
      expect(current_path).to eq("/items/#{@chain.id}")
      expect(page).to_not have_css("#review-#{review_1_id}")
    end
  end
end
