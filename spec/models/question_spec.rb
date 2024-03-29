# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  subject(:question) { build :question }

  it { should belong_to(:user) }

  it { should have_many(:answers).order('best DESC, created_at').dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy)}

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#subscribe_author' do
    it "create subscription of author to question after create" do
      question.save
      expect(question.user).to be_subscribed(question)
    end
  end
end
