FactoryGirl.define do
  factory :post do
    association :user
    association :target
    text {Faker::Superhero.power}
    amount {Faker::Number.number(3)}
    trait :type_text do
      post_type {Post.post_types[:text]}
    end
    trait :type_transaction do
      post_type {Post.post_types[:transactions]}
    end
    trait :type_request do
      post_type {Post.post_types[:request]}
    end
  end
end