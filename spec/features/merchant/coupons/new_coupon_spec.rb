require 'rails_helper'

RSpec.describe 'Merchant add coupon' do
  describe 'as a merchant employee' do
    before :each do
      @merchant_1 = create :merchant
      @merchant_user = create :random_merchant_user, merchant: @merchant_1
      @coupon = create :coupon, merchant: @merchant_1
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'has a link to add coupons' do
      visit '/merchant'

      click_on 'Add Coupon'
      expect(current_path).to eq('/merchant/coupons/new')
    end

    it 'can create a coupon when form is submitted' do
      visit '/merchant/coupons/new'

      fill_in :name, with: 'Coupon1'
      fill_in :code, with: 'epsteindidnotkillhimself'
      fill_in :percent_off, with: '15'

      click_button 'Add Coupon'

      coupon = Coupon.last
      expect(current_path).to eq('/merchant/coupons')
      within "#coupon-#{coupon.id}" do
        expect(page).to have_content('Coupon1')
        expect(page).to have_content('epsteindidnotkillhimself')
        expect(page).to have_content('15')
      end
    end

    it 'can visit a page containing list of all coupons' do
      visit '/merchant/coupons'

      expect(page).to have_content(@coupon.name)
      expect(page).to have_content(@coupon.code)
      expect(page).to have_content(@coupon.percent_off)
    end

    it 'will fail to add coupon if field is blank' do
      visit '/merchant/coupons/new'

      fill_in :name, with: 'Name'
      fill_in :percent_off, with: '12'

      click_button 'Add Coupon'

      expect(current_path).to eq('/merchant/coupons/new')
      expect(page).to have_content("Code can't be blank")
    end

    it 'will fail to add coupon if name is not unique' do
      visit '/merchant/coupons/new'

      fill_in :name, with: @coupon.name
      fill_in :code, with: 'thisisacode'
      fill_in :percent_off, with: '12'

      click_button 'Add Coupon'

      expect(current_path).to eq('/merchant/coupons/new')
      expect(page).to have_content("Name has already been taken")
    end

    it 'will fail to add coupon if code is not unique' do
      visit '/merchant/coupons/new'

      fill_in :name, with: 'Name'
      fill_in :code, with: @coupon.code
      fill_in :percent_off, with: '12'

      click_button 'Add Coupon'

      expect(current_path).to eq('/merchant/coupons/new')
      expect(page).to have_content("Code has already been taken")
    end

    it 'can create coupon that is one use only' do
      visit '/merchant/coupons/new'

      fill_in :name, with: 'Coupon1'
      fill_in :code, with: 'epsteindidnotkillhimself'
      fill_in :percent_off, with: '15'
      page.check(:one_use?)
      click_button 'Add Coupon'

      coupon = Coupon.last
      expect(current_path).to eq('/merchant/coupons')
      within "#coupon-#{coupon.id}" do
        expect(page).to have_content('Coupon1')
        expect(page).to have_content('epsteindidnotkillhimself')
        expect(page).to have_content('15')
      end   
    end
  end
end
