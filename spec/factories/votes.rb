FactoryBot.define do
  factory :vote do
    value { 1 }

    association :user, factory: :user
    association :voteable, factory: :question

    trait :answer_vote do
      association :voteable, factory: :answer
    end

    trait :positive do
      value { 1 }
    end

    trait :negative do
      value { -1 }
    end

    factory :positive_vote, traits: [:positive]
    factory :negative_vote, traits: [:negative]
  end
end
