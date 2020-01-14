class AddColumnsToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :discount, :float
    add_column :order_items, :revenue, :float
  end
end
