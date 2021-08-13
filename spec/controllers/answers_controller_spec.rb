require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:other_answer) { create(:answer) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params }, format: :js }
    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }
      it 'saves a new answer in the database' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'adds a answer to the user' do
        expect { post_create }.to change(user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }
      it 'does not save the question' do
        expect { post_create }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: { id: answer.id, answer: { body: new_body } }, format: :js }

    let!(:answer) { create(:answer, user: user, question: question) }
    let(:body) { answer.body }
    let(:new_body) { 'new body' }

    it 'updates the answer in the database' do
      expect { patch_update }.to change { answer.reload.body }.from(body).to(new_body)
    end

    context 'with invalid attributes' do
      let(:new_body) { nil }

      it 'does not update the answer' do
        expect { patch_update }.not_to change { answer.body }
      end
    end

    context 'when the user is not the author' do
      it 'returns forbidden' do
        patch :update, params: {id: other_answer, format: :js}
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: answer.id }, format: :js}

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'should delete answer' do
      expect { delete_destroy}.to change(question.answers, :count).by(-1)
    end

    context 'when the user is not the author' do
      let!(:answer) { create(:answer, question: question) }

      it 'should not delete answer' do
        expect { delete_destroy }.not_to change(question.answers, :count)
      end

      it 'returns forbidden' do
        delete_destroy
        expect(response).to be_forbidden
      end
    end
  end

  describe 'POST #mark_as_best' do
    let(:post_mark) { post :mark_as_best, params: { id: answer_id }, format: :js }
    let(:answer_id) { answer.id }

    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    it 'should marks answer as best' do
      post_mark
      answer.reload
      expect(answer.best).to eq true
    end

    context 'when the user is not the question author' do
      let(:answer_id) { other_answer }

      it 'should not marks answer as best' do
        post_mark
        answer.reload
        expect(answer.best).to_not eq true
      end

      it 'returns forbidden' do
        post_mark
        expect(response).to be_forbidden
      end
    end
  end
end
