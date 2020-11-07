require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
      it {should belong_to :merchant}
  end

    describe "validations" do
      it { should validate_presence_of :name }
      it { should validate_presence_of :min_quantity }
      it { should validate_presence_of :discount_percent }
    end
end
