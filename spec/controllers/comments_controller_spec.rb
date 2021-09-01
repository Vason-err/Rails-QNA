require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    subject do
      post :create, params: {
        commentable_type: commentable_type,
        commentable_id: commentable.id,
        comment: { text: text }
      },
           format: :js
    end

    let(:text) { 'text' }
    let!(:commentable) { create(:question) }
    let!(:commentable_type) { 'question' }

    context 'create comment' do
      it 'should create comment' do
        expect { subject }.to change(Comment, :count).by(1)
      end

      context 'when answer comment' do
        let!(:commentable) { create(:answer) }
        let!(:commentable_type) { 'answer' }

        it 'should create comment' do
          expect { subject }.to change(Comment, :count).by(1)
        end
      end
    end

    context 'with invalid params' do
      let(:text) { nil }

      it 'should not create comment' do
        expect { subject }.not_to change(Comment, :count)
      end
    end
  end
end
