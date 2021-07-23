FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { build(:question) }
  end
end
