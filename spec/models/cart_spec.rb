require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        }, nil)
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

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it 'apply_coupon' do
      @cart.apply_coupon('merchant_id' => 12, 'discount' => 15)
      expect(@cart.applied_coupon).to eq({'merchant_id' => 12, 'discount' => 15})
    end
  end

  describe 'methods with coupon applied' do
    before :each do
      @merchant_1 = create :merchant
      @merchant_2 = create :merchant
      @merchant_3 = create :merchant
      @item_1 = create :item, merchant: @merchant_1, price: 100
      @item_2 = create :item, merchant: @merchant_2, price: 100
      @coupon = Coupon.create(name: 'test', code: 'test', percent_off: 10, merchant: @merchant_1)
      @coupon_2 = Coupon.create(name: 'test1', code: 'test1', percent_off: 10, merchant: @merchant_3)
      @cart = Cart.new({@item_1.id.to_s => 1, @item_2.id.to_s => 1},
                       {'merchant_id' => @coupon.merchant_id, 'discount' => @coupon.percent_off})
    end

    it 'discount_amount' do
      expect(@cart.discount_amount(@item_1)).to eq(10)
      expect(@cart.discount_amount(@item_2)).to eq(0)
    end

    it 'total discount' do
      expect(@cart.total_discount).to eq(10)
    end

    it 'subtotal_of' do
      expect(@cart.subtotal_of(@item_1.id)).to eq(90)
      expect(@cart.subtotal_of(@item_2.id)).to eq(100)
    end

    it 'eligible_code?' do
      expect(@cart.eligible_code?('test')).to be true
      expect(@cart.eligible_code?('sdfsdfsdf')).to be false
      expect(@cart.eligible_code?('test1')).to be false
    end

    it 'applied_coupon' do
      expect(@cart.applied_coupon).to eq({'merchant_id' => @coupon.merchant_id, 'discount' => @coupon.percent_off})
    end
  end
end
