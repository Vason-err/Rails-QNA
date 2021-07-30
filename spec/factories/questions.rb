FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} title" }
    sequence(:body) { |n| "Question #{n} body" }

    association :user, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
