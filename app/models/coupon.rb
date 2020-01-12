class Coupon < ApplicationRecord
  validates_presence_of :name,
                       :code,
                       :percent_off

  validates_uniquness_of :name,
                         :code

  belongs_to :merchant
end
