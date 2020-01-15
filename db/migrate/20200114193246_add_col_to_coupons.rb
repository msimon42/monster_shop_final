class AddColToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :one_use?, :boolean, default: false
  end
end
