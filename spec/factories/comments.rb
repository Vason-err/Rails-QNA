FactoryBot.define do
  factory :comment do
    text { 'text' }

    association :user, factory: :user
    association :commentable, factory: :question

    trait :answer_comment do
      association :commentable, factory: :answer
    end
  end
end
