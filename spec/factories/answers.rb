FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    association :user, factory: :user
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end

    trait :best do
      after :create do |answer|
        answer.mark_as_best
      end
    end
  end
end
