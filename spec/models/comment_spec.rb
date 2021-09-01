require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :text }

  describe '#ws_stream_name' do
    subject { comment.ws_stream_name }

    context 'when question comment' do
      let(:comment) { create(:comment) }

      it do
        is_expected.to eq("questions/#{comment.commentable_id}/comments")
      end
    end

    context 'when answer comment' do
      let(:comment) { create(:comment, :answer_comment) }

      it do
        is_expected.to eq("questions/#{comment.commentable.question_id}/comments")
      end
    end
  end
end
