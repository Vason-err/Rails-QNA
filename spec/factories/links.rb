# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    name { 'Test link' }
    url { 'http://foo.bar.com' }
  end
end
