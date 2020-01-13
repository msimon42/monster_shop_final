class AddDiscountAmtToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :discount, :float, default: 0
  end
end
