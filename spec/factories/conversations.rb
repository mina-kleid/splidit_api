FactoryGirl.define do
  factory :conversation do
    association :first_user
    association :second_user
  end
end