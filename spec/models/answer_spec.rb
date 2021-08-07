require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user)}
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }

  describe 'best answer' do
    let(:answer) { create(:answer) }
    let(:question) { answer.question }

    describe '#mark_as_best' do
      subject { answer.mark_as_best }

      it do
        expect { subject }.to change { question.reload.best_answer_id }.from(nil).to(answer.id)
      end
    end

    describe '#best?' do
      it { expect(answer).not_to be_best }

      context 'when best' do
        let(:answer) { create(:answer, :best) }

        it { expect(answer).to be_best }
      end
    end
  end
end
