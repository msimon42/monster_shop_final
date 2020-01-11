FactoryBot.define do
  factory :random_user, class: User do
    name {Faker::Name.name_with_middle}
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip {Faker::Address.zip_code}
    email {Faker::Internet.email}
    password {Faker::Internet.password}
  end

  factory :random_merchant_user, class: User do
    name {Faker::Name.name}
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip {Faker::Address.zip_code}
    email {Faker::Internet.email}
    password {'password'}
    role {1}
    association :merchant
  end

  factory :random_admin_user, class: User do
    name {Faker::Name.name_with_middle}
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip {Faker::Address.zip_code}
    email {Faker::Internet.email}
    password {'password'}
    role {2}
  end

  factory :random_reg_user_test, class: User do
    name {Faker::Name.name_with_middle}
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip {Faker::Address.zip_code}
    email {Faker::Internet.email}
    password {'password'}
    role {0}
  end
end
