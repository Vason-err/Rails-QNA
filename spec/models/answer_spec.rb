require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user)}
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }

  describe 'best answer' do
    let(:answer) { create(:answer) }
    let(:question) { answer.question }

    it 'select this answer best' do
      expect(answer).to_not be_best
      answer.mark_as_best
      expect(answer).to be_best
    end

    it 'deselect other answers' do
      best_answer = create(:answer, question: question, best: true)
      answer.mark_as_best
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end
end
