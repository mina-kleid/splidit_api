FactoryGirl.define do
  factory :request do
    association :target
    association :source
    text {Faker::Superhero.power}
    trait :pending do
      status {Request.statuses[:pending]}
    end
    trait :rejected do
      status {Request.statuses[:rejected]}
    end
    trait :accepted do
      status {Request.statuses[:accepted]}
    end
  end
end