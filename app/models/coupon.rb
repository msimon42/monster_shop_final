class Coupon < ApplicationRecord
  validates_presence_of :name,
                       :code,
                       :percent_off

  validates_uniqueness_of :name,
                         :code

  belongs_to :merchant
  has_many :orders
end
