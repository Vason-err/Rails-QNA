require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { voteable_id: question.id, voteable_type: 'question', value: 1 }, format: :js }

    let(:question) { create(:question) }
    let(:last_vote) { Vote.last }

    it 'should create vote' do
      expect { post_create }.to change(Vote, :count).by(1)
      expect(last_vote).to have_attributes(
                             user_id: user.id,
                             voteable_id: question.id,
                             voteable_type: 'Question',
                             value: 1
                           )
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(last_vote.to_json)
    end

    context 'when invalid params' do
      let(:post_create) { post :create, params: { voteable_id: question.id, voteable_type: 'question' }, format: :js }

      it 'should not create vote' do
        expect { post_create }.not_to change(Vote, :count)
        expect(response.body).to eq("{\"errors\":[\"Value can't be blank\",\"Value is not included in the list\"]}")
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: vote.id }, format: :js }

    let!(:vote) { create(:vote, user: user) }

    it 'should delete vote' do
      expect { delete_destroy }.to change(Vote, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(vote.to_json)
    end

    context 'when the user is not the author' do
      let!(:vote) { create(:vote) }

      it 'should not delete vote' do
        expect { delete_destroy }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
