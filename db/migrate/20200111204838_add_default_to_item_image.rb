class AddDefaultToItemImage < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, :default => 'https://live.staticflickr.com/1227/543067160_688e299f21_z.jpg'
  end
end
