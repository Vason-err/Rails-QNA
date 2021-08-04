FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    association :user, factory: :user
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end
  end
end
