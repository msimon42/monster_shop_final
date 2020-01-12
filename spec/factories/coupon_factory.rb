FactoryBot.define do
  factory :coupon, class: Coupon do
    name {Faker::Alphanumeric.alphanumeric}
    code {Faker::Alphanumeric.alphanumeric}
    percent_off {rand(5..15)}
    association :merchant
  end
end
