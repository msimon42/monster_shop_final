FactoryBot.define do
  factory :item, class: Item do
    name {Faker::Book.title}
    description {Faker::Book.genre}
    author {Faker::Book.author}
    price {rand(2..50)}
    inventory {rand(500)}
    #image {Faker::LoremFlickr.image(size: "300x300", search_terms: ['book'])}
  end
end
