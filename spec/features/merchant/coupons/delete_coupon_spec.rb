require 'rails_helper'

RSpec.describe 'As a merchant user' do
  describe 'I can delete a coupon' do
    before :each do
      @merchant_1 = create :merchant
      @merchant_user = create :random_merchant_user, merchant: @merchant_1
      @coupon = create :coupon, merchant: @merchant_1
      @coupon_2 = create :coupon, merchant: @merchant_1
      order = create :order, coupon: @coupon_2, user: @merchant_user
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'can delete coupon' do
      visit '/merchant/coupons'

      within "#coupon-#{@coupon.id}" do
        click_button 'Delete'
      end

      expect(page).to have_content('Coupon deleted')
      expect(page).to_not have_css("coupon-#{@coupon.id}")
    end

    it 'cannot delete coupon with orders' do
      visit '/merchant/coupons'

      within "#coupon-#{@coupon_2.id}" do
        click_button 'Delete'
      end

      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_css("#coupon-#{@coupon_2.id}")
      expect(page).to have_content('Coupons with orders cannot be deleted')
    end
  end

  describe 'I can deactivate a coupon' do
    before :each do
      @merchant_1 = create :merchant
      @merchant_user = create :random_merchant_user, merchant: @merchant_1
      @coupon = create :coupon, merchant: @merchant_1
      @coupon_2 = create :coupon, merchant: @merchant_1
      order = create :order, coupon: @coupon_2, user: @merchant_user
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'deactivate coupon' do
      visit '/merchant/coupons'

      within "#coupon-#{@coupon.id}" do
        click_button 'Deactivate'
      end
    end
  end
end
