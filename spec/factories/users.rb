# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_user_#{n}@test.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
