require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )
      @orc = @megan.items.create!(name: 'Orc', description: "I'm an Orc!", price: 70, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 42 )
      @elf = @megan.items.create!(name: 'Elf', description: "I'm an Elf!", price: 90, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 21 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
      @discount_1 = BulkDiscount.create!(
        description: '5% off 20+',
        discount_percent: 5,
        minimum_quantity: 20,
        merchant: @megan
      )
      @discount_2 = BulkDiscount.create!(
        description: '10% off 40+',
        discount_percent: 10,
        minimum_quantity: 40,
        merchant: @megan
      )
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.total_items' do
      expect(@cart.total_items).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq({@ogre => 1, @giant => 2})
    end

    it '.total' do
      expect(@cart.total).to eq(120)
      42.times do
        @cart.add_item(@orc.id.to_s)
      end
      21.times do
        @cart.add_item(@elf.id.to_s)
      end
      expect(@cart.total).to eq(4561.50)
    end

    it '.subtotal' do
      42.times do
        @cart.add_item(@orc.id.to_s)
      end
      21.times do
        @cart.add_item(@elf.id.to_s)
      end

      expect(@cart.subtotal(@ogre.id)).to eq(20)
      expect(@cart.subtotal(@giant.id)).to eq(100)
      expect(@cart.subtotal(@orc.id).round(2)).to eq(2646)
      expect(@cart.subtotal(@elf.id).round(2)).to eq(1795.5)
    end

    it '.decrement_item' do
      @cart.decrement_item(@giant)
      expect(@cart.total_items).to eq(2)
    end
  end
end
