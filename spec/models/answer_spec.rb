# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    let(:user) { create(:user) }
    let(:question_with_answers) { create(:question, :with_answers) }
    let(:first_answer) { question_with_answers.answers.first }
    let!(:reward) { create(:reward, question: question_with_answers) }
    let(:answer) { create(:answer, question: question_with_answers, user: user) }
    let(:best_answer) { create(:answer, question: question_with_answers, best: true) }

    it 'select this answer best' do
      expect { first_answer.mark_as_best }.to change { first_answer.best }.from(false).to(true)
    end

    it 'deselect other answers' do
      best_answer
      first_answer.mark_as_best
      best_answer.reload
      expect(best_answer).to_not be_best
      expect(question_with_answers.answers.last).to_not be_best
    end

    it 'assigns an award from author of the answer' do
      expect(reward.user).to_not eq user
      answer.mark_as_best
      expect(reward.user).to eq user
    end
  end
end
