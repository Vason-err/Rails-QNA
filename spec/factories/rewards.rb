# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title { 'MyString' }
    user
    question
  end
end
