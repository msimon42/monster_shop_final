# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
OrderItem.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all
Item.destroy_all

merchants = FactoryBot.create_list(:merchant, 15)
items = Array.new
merchants.each do |merchant|
  items << FactoryBot.create_list(:item, 30, merchant: merchant)
  FactoryBot.create(:random_merchant_user, merchant: merchant)
end
items.flatten!
users = FactoryBot.create_list(:random_user, 100)

# create some orders
orders = FactoryBot.create_list(:order, 25)
orders.each do |order|
  order_items = items.sample(3)
  order_items.each do |item|
    OrderItem.create(order_id: order.id, item_id: item.id, price: item.price, quantity: rand(item.inventory))
  end
end

# create some fufilled orders
orders = FactoryBot.create_list(:order, 15)
orders.each do |order|
  order_items = items.sample(3)
  order_items.each do |item|
    OrderItem.create(order_id: order.id, item_id: item.id, price: item.price, quantity: rand(item.inventory), fulfilled: true)
  end
end

# create some packaged orders
orders = FactoryBot.create_list(:order, 15, status: 1)
orders.each do |order|
  order_items = items.sample(3)
  order_items.each do |item|
    OrderItem.create(order_id: order.id, item_id: item.id, price: item.price, quantity: rand(item.inventory), fulfilled: true)
  end
end

admin = User.create(
  name: 'admin',
  email: 'admin@admin.io',
  password: 'password',
  address: '420 main St',
  city: 'Yourtown',
  state: 'CO',
  zip: '80000',
  role: 2
)

merchant_user = User.create(
  name: 'merchant',
  email: 'merchant@merchant.com',
  password: 'password',
  address: '420 Main St',
  city: 'Yourtown',
  state: 'CO',
  zip: '80000',
  role: 1,
  merchant_id: merchants.first.id
)

regular_user= User.create(
  name: 'Regular User',
  email: 'regularuser@user.com',
  password: 'password',
  address: '420 Main St',
  city: 'Yourtown',
  state: 'CO',
  zip: '80000',
  role: 0
)
