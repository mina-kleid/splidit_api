FactoryGirl.define do
  factory :request do
    association :target
    association :source
    text {Faker::Superhero.power}
    trait :pending do
      status {Request.statuses[:request_pending]}
    end
    trait :rejected do
      status {Request.statuses[:request_rejected]}
    end
    trait :accepted do
      status {Request.statuses[:request_accepted]}
    end
  end
end