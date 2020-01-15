require 'rails_helper'

RSpec.describe 'Merchant edit coupon' do
  describe 'as a merchant employee' do
    before :each do
      @merchant_1 = create :merchant
      @merchant_user = create :random_merchant_user, merchant: @merchant_1
      @coupon = create :coupon, merchant: @merchant_1
      @coupon_2 = create :coupon, merchant: @merchant_1
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'has a link to edit coupon on dashboard' do
      visit '/merchant/coupons'

      within "#coupon-#{@coupon.id}" do
        click_on 'Update'
      end

      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}/edit")
    end

    it 'can edit coupon through edit form' do
      visit "/merchant/coupons/#{@coupon.id}/edit"

      fill_in :code, with: 'bushliedpeopledied'
      click_on 'Update Coupon'

      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_content('Coupon updated')

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_content('bushliedpeopledied')
      end
    end

    it 'will not update if field is left blank' do
      visit "/merchant/coupons/#{@coupon.id}/edit"

      fill_in :name, with: ''
      click_on 'Update Coupon'

      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}/edit")
      expect(page).to have_content("Name can't be blank")
    end

    it 'will not update if code is not unique' do
      visit "/merchant/coupons/#{@coupon.id}/edit"

      fill_in :code, with: @coupon_2.code
      click_on 'Update Coupon'

      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}/edit")
      expect(page).to have_content("Code has already been taken")
    end

    it 'will not update if name is not unique' do
      visit "/merchant/coupons/#{@coupon.id}/edit"

      fill_in :name, with: @coupon_2.name
      click_on 'Update Coupon'

      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}/edit")
      expect(page).to have_content("Name has already been taken")
    end

    it 'can change to one use only in edit form' do
      visit "/merchant/coupons/#{@coupon.id}/edit"
      page.check(:one_use?)
      click_on 'Update Coupon'

      expect(current_path).to eq('/merchant/coupons')
      within "#coupon-#{@coupon.id}" do
        expect(page).to have_content('TRUE')
      end
    end
  end
end
