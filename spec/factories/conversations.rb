FactoryGirl.define do
  factory :conversation do
    association :first_user
    association :second_user
    trait :with_posts do
      transient do
        post_count 20
      end
      after(:create) do |conversation, evaluator|
        evaluator.post_count.times do
            create(:conversation_post, :type_text, user: conversation.first_user, conversation: conversation)
            create(:conversation_post, :type_text, user: conversation.second_user, conversation: conversation)
        end
      end
    end
  end
end