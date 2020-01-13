class Coupon < ApplicationRecord
  validates_presence_of :name,
                       :code

  validates_uniqueness_of :name,
                         :code

  validates_inclusion_of :percent_off, in: 0..100, message: 'Discount must be between 0 and 100%'                       

  belongs_to :merchant
  has_many :orders
end
