require 'rails_helper'

describe BulkDiscount do
  describe 'Validations' do
    it { should validate_presence_of :description }
    it { should validate_presence_of :minimum_quantity }
    it { should validate_presence_of :discount_percent }
  end

  describe 'Relationships' do
    it { should belong_to :merchant}
  end
end
