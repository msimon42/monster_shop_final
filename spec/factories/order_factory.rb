FactoryBot.define do
  factory :order, class: Order do
    user_id {(create :random_user).id}
  end
end
