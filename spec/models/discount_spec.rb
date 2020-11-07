require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it {should have_many :discount_items}
    it {should have_many(:items).through(:discount_items)}
  end
end
