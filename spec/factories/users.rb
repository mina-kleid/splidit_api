FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password(8)}
    phone {'0176' + Faker::Number.number(8)}
    authentication_token {Faker::Superhero.power}
    after(:create) do |instance|
      instance.account.balance = 100
      instance.account.save!
    end
  end
end