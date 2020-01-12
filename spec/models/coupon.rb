require 'rails_helper'

RSpec.describe Coupon do
  describe 'Relationships' do
    it {should have_many :orders}
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :code}
    it {should validate_presence_of :percent_off}
    it {should validates_uniquness_of :name}
    it {should validates_uniquness_of :code}
  end
end
