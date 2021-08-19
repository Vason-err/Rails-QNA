require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user)}
  it { should belong_to(:question) }

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    let(:question_with_answers) { create(:question, :with_answers) }
    let(:first_answer) { question_with_answers.answers.first }
    let(:best_answer) { create(:answer, question: question_with_answers, best:true) }

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
  end
end
