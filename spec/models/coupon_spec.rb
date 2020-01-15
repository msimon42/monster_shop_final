require 'rails_helper'

RSpec.describe Coupon do
  describe 'Relationships' do
    it {should have_many :orders}
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :code}
    it {should validate_inclusion_of(:percent_off)
              .in_range(0..100)
              .with_message('Discount must be between 0 and 100%')}
    it {should validate_uniqueness_of :name}
    it {should validate_uniqueness_of :code}
  end

  describe 'methods' do
    it 'already_used?' do
      @user = create :random_user
      @user_2 = create :random_user
      @coupon = create :coupon
      @order = create :order, user: @user, coupon: @coupon

      expect(@coupon.already_used?(@user)).to be true
      expect(@coupon.already_used?(@user_2)).to be false
    end
  end
end
