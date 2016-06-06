FactoryGirl.define do
  factory :account do
    name {Faker::Name.name}
    iban {"DE89370400440532013000"}
    account_holder {Faker::Name.name}
    association :user
  end
end