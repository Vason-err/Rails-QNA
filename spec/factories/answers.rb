FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    association :user, factory: :user
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end
    
    trait :with_file do
      after :create do |answer|
        answer.files.attach(
          io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename: 'rails_helper.rb',
          content_type: 'text/rb'
        )
      end
    end

    trait :best do
      after :create do |answer|
        answer.mark_as_best
      end
    end
  end
end
