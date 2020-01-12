class Coupon < ApplicationRecord
  validates_uniquness_of :name, :code
  belongs_to :merchant
end
