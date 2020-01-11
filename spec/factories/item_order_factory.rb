FactoryBot.define do
  factory :order_item, class: OrderItem do
    association :order
    association :item
    price {Faker::Commerce.price(range: 2.0..10.0)}
    quantity {rand(1..50)}
  end
end
