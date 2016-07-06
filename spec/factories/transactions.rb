FactoryGirl.define do
  factory :transaction do
    association :target
    association :source
    text {Faker::Superhero.power}
    amount {10}
    trait :credit do
      transaction_type {Transaction.transaction_types[:credit]}
    end
    trait :debit do
      transaction_type {Transaction.transaction_types[:debit]}
    end
  end
end