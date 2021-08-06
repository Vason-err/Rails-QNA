FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} title" }
    sequence(:body) { |n| "Question #{n} body" }

    association :user, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_best_answer do
      after :create do |question|
        create_list :answer, 3, question: question
        question.answers.last.mark_as_best
      end
    end
  end
end
