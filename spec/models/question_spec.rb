require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:best_answer).class_name('Answer').optional }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  describe '#answers_without_best' do
    subject { question.answers_without_best }

    let(:question) { create(:question, :with_best_answer) }
    let(:answers) { question.answers.where.not(id: question.best_answer_id) }

    it 'should answers without best' do
      is_expected.to match_array(answers)
    end
  end
end
