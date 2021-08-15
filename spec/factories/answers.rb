FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    association :user, factory: :user
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end
    
    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :best do
      after :create do |answer|
        answer.mark_as_best
      end
    end
  end
end
